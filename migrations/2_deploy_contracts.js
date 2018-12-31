var DormitoryFee = artifacts.require("./DormitoryFee.sol");

module.exports = function(deployer) {
  deployer.deploy(DormitoryFee);
};
