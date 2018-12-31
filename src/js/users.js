import contract from 'truffle-contract'
import DormitoryFee from '@contracts/DormitoryFee.json'

const Users = {

  contract: null,

  instance: null,

  address: null,

  init: function (address) {
    let self = this

    return new Promise(function (resolve, reject) {
      self.contract = contract(DormitoryFee);
      self.contract.setProvider(window.web3.currentProvider);
      self.address = address;
      self.contract.deployed().then(instance => {
        self.instance = instance;
      }).catch(err => {
        console.log(err);
      })
    })
  },

  getUsers: function() {
    let self = this;

    return self.instance.getUsers();
  },

  getAdministrator: function() {
    let self = this;

    return self.instance.getAdministrator();
  },

  getBalance: function() {
    let self = this;

    return self.instance.getBalance();
  },

  getCommitedUsers: function() {
    let self = this;

    return self.instance.getCommitedUsers();
  },

  getNumberOfUsers: function() {
    let self = this;

    return self.instance.getNumberOfUsers();
  },

  getTotalNumberOfTransactions: function() {
    let self = this;

    return self.instance.getTotalNumberOfTransactions();
  },

  getBill: function() {
    let self = this;

    return self.instance.getBill();
  },

  getTransaction: function(index) {
    let self = this;

    return self.instance.getTransactions(index);
  },

  confirmTransaction: function(index) {
    let self = this;

    return self.instance.confirmTransaction(index, {from: self.address});
  },

  commitTransaction: function(name, money) {
    let self = this;
    return self.instance.commitTransaction(name, money, {from: self.address});
  },

  commitFee: function() {
    let self = this;

    return self.instance.commitFee({from: self.address, value:100});
  },

  deleteUser: function(address) {
    let self = this;

    return self.instance.deleteUser(address, {from: self.address});
  },

  addUser: function(address) {
    let self = this;

    return self.instance.addUser(address, {from: self.address});
  }

}

export default Users
