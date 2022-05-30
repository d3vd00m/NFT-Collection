require("@nomiclabs/hardhat-waffle");
require("dotenv").config({ path: ".env" });

const ALCHEMY_API_KEY_URL = process.env.ALCHEMY_API_KEY_URL;

const DEVELOPER_PRIVATE_KEY = process.env.DEVELOPER_PRIVATE_KEY;

module.exports = {
  solidity: "0.8.4",
  networks: {
    matic: {
      url: ALCHEMY_API_KEY_URL,
      accounts: [DEVELOPER_PRIVATE_KEY],
    },
  },
};
