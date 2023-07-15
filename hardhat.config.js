require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.19",
  defaultNetwork: "rinkeby",
  networks: {
    rinkeby: {
      url: "https://goerli.infura.io/v3/7dd83e9ec62348eebba6f1c0adffa5a6",
      accounts: [
        "7927520d0815e6c172899c5afc7dabe6849f09bc4499287b3e28edf7f84ae44c",
        "425ace9f7e2d0fc0047c95f72b1f7ea0f894672009616311f10b30dc4e21722c",
      ],
    },
  },
};
