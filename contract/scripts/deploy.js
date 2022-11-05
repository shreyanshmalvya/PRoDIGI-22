const hre = require("hardhat");

async function main() {
  const LoyaltyPoints = await hre.ethers.getContractFactory("LoyaltyPoints");
  const loyaltypoints = await LoyaltyPoints.deploy();


  await loyaltypoints.deployed();

  console.log("LoyaltyPoints deployed to:", loyaltypoints.address);
}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
