const hre = require("hardhat");

async function main() {
  let address_owner = "0xf91208e34b46d6c0fad249ee7dd598f903d8db38",
    address_stableCoin = "0x8Ec7f2746d9098a627134091bC9aFB4629A8642D",
    address_uniswapRouter = "0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D";

  const Treasury = await hre.ethers.deployContract("Treasury", [
    address_owner,
    address_stableCoin,
    address_uniswapRouter,
  ]);

  await Treasury.waitForDeployment();

  console.log(`Treasury Contract is deployed to ${Treasury.target}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
