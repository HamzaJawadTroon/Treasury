pragma solidity ^0.8.0;

// Import ERC20 interface
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// Import Uniswap V2 interface
import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";

// Interface for Beefy Finance protocol for calculating yield
interface IBeefy {
    function calculateYield() external view returns (uint);
}

contract Treasury {
    // Address of the owner of the smart contract
    address public owner;

    // Address of the USDC or other stable coin token
    address public stableCoin;

    // Array of protocol addresses to add liquidity to
    address[] public protocols;

    // Array of ratios for distributing funds to each protocol
    uint[] public ratios;

    // Uniswap V2 router contract
    IUniswapV2Router02 public uniswapRouter;

    constructor(
        address _owner,
        address _stableCoin,
        address _uniswapRouter
    ) {
        owner = _owner;
        stableCoin = _stableCoin;
        uniswapRouter = IUniswapV2Router02(_uniswapRouter);
    }

    // Function to deposit funds into the treasury contract
    function deposit(uint amount) external {
        // Transfer USDC or other stable coin from sender to the treasury contract
        IERC20(stableCoin).transferFrom(msg.sender, address(this), amount);
    }

    // Function to add liquidity to protocols
    function addLiquidity() external {
        // Calculate total balance of stable coin in the treasury contract
        uint totalBalance = IERC20(stableCoin).balanceOf(address(this));

        // Loop through protocols and add liquidity according to ratios
        for (uint i = 0; i < protocols.length; i++) {
            // Calculate the amount of the protocol's currency to buy with the stable coin
            uint amountOut = totalBalance * ratios[i] / 100;

            // Swap stable coin for the protocol's currency
            address[] memory path = new address[](2);
            path[0] = stableCoin;
            path[1] = IUniswapV2Pair(protocols[i]).token1();

            uint deadline = block.timestamp + 300;
            uint[] memory amounts = uniswapRouter.swapExactTokensForTokens(
                amountOut,
                0,
                path,
                address(this),
                deadline
            );

            // Add liquidity to the pool
            IERC20(path[0]).approve(address(uniswapRouter), amounts[0]);
            IERC20(path[1]).approve(address(uniswapRouter), amounts[1]);

            uniswapRouter.addLiquidity(
                path[0],
                path[1],
                amounts[0],
                amounts[1],
                0,
                0,
                address(this),
                deadline
            );
        }
    }

    // Function to set the ratios for distributing funds to protocols
    function setRatios(uint[] memory _ratios) external {
        require(msg.sender == owner, "Only the owner can set ratios");
        require(_ratios.length == protocols.length, "Ratios length must match protocols length");

        ratios = _ratios;
    }

    // Function to withdraw funds from a protocol
    function withdraw(address pool, uint amount) external {
        require(msg.sender == owner, "Only the owner can withdraw funds");

        // Remove liquidity from the pool
        IUniswapV2Pair(pool).approve(address(uniswapRouter), amount);
        (uint amount0, uint amount1) = uniswapRouter.removeLiquidity(
            IUniswapV2Pair(pool).token0(),
            IUniswapV2Pair(pool).token1(),
            amount,
            0,
            0,
            address(this),
            block.timestamp + 300
        );

        // Swap the protocol's currency for stable coin
        address[] memory path = new address[](2);
        path[0] = IUniswapV2Pair(pool).token1();
        path[1] = stableCoin;

        uint[] memory amounts = uniswapRouter.swapExactTokensForTokens(
            amount1,
            0,
            path,
            address(this),
            block.timestamp + 300
        );

        // Transfer stable coin to the owner
        IERC20(stableCoin).transfer(owner, amounts[1]);
    }

    // Function to calculate the aggregated percentage yield of all the protocols
    function calculateYield() external view returns (uint, string memory) {
            uint totalYield = 0;

            // Loop through protocols and calculate yield for each one
            for (uint i = 0; i < protocols.length; i++) {
                // Calculate the yield for this protocol and add it to the total yield
                // uint protocolYield = IBeefy(protocols[i]).calculateYield();
                // totalYield += protocolYield;
            }

            return (totalYield, "Sory could't manage time to do the RND on BEEFY");
        }
}