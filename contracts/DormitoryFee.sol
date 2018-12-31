pragma solidity ^0.4.22;

contract DormitoryFee {
    //administrator
    address administrator;
    
    //users
    address[4] users;
    
    //users who have commit fee
    address[4] commitedUsers;
    
    //the number of users
    uint usersNumber;
    
    //balance of this contract account
    uint balance;
    
    //the number of money to be confirmed
    uint bill;
    
    //definition of transaction
    struct transaction {
        uint index;
        address user;
        string name;
        uint money;
        uint confirmUsersNumber;
        address[3] confirmUsers;
    }
    
    //list of transactions
    transaction[] transactions;

    //constructor of this contract
    constructor() public {
        administrator = msg.sender;
        users[usersNumber] = msg.sender;
        usersNumber = 1;
        balance = 0;
        bill = 0;
    }
    
    //determine whether the msg.sender is simple user
    // function isUser(address user) public view returns (bool) {
    //     for (uint i = 0; i < 4; i++) {
    //         if(user == users[i]) return true;
    //     }
    //     return false;
    // }
    
    //determine whether the msg.sender is the administrator
    // function isAdministrator(address user) public view returns (bool) {
    //     return user == administrator;
    // }
    
    //determine whether the user has commited fee
    // function isCommitedUser(address user) public view returns (bool) {
    //     for (uint i = 0; i < 4; i++) {
    //         if (user == commitedUsers[i]) return true;
    //     }
    //     return false;
    // }
    
    //determine whether balance is enough to pay the bill
    // function isEnough() public view returns (bool) {
    //     return bill <= balance;
    // }
    
    //add users
    function addUser(address user) public returns(bool) {
        // require(usersNumber < 4, "require that the number of users doesn't exceed 4");
        // require(isAdministrator(msg.sender), "require that you are the administrator to add users");
        // require(!isUser(user), "require that the users to be added haven't be added before");
        for(uint i = 0; i < 4; i++) {
            if (users[i] == 0x0000000000000000000000000000000000000000) {
                users[i] = user;
                usersNumber++;
                return true;
            }
        }
    }
    
    //get the index of user
    function indexOfUser(address user) public view returns(uint) {
        for (uint i = 0; i < 4; i++) {
            if (user == users[i]) return i;
        }
    }
    
    //delete users
    function deleteUser (address user) public returns(bool) {
        // require(isAdministrator(msg.sender), "require that you are the administrator to add users");
        // require(isUser(user), "require that the users to be added have be added before");
        delete users[indexOfUser(user)];
        usersNumber--;
        return true;
    }
    
    //commit dormitory fee
    function commitFee() public payable {
        // require(isUser(msg.sender), "require that you are a member of this dormitory" );
        // require(!isCommitedUser(msg.sender), "require that you haven't commited dormitory fee");
        // require(msg.value == 100, "require the right money 100");
        commitedUsers[indexOfUser(msg.sender)] = msg.sender;
        balance += msg.value; 
    }
    
    
    //commit a transaction
    function commitTransaction(string name, uint money) public returns (uint) {
        // require(isUser(msg.sender), "require that you are a member of this dormitory" );
        // require(isCommitedUser(msg.sender), "require that you have commited dormitory fee");
        transactions.push(transaction({
            index:transactions.length,
            user: msg.sender,
            name: name,
            money: money,
            confirmUsersNumber:0,
            confirmUsers: [
                0x0000000000000000000000000000000000000000,
                0x0000000000000000000000000000000000000000,
                0x0000000000000000000000000000000000000000]
        }));
        bill += money;
        if (bill > money) {
            delete commitedUsers;
        }
        return transactions.length;
    }
    
    //confirm a transaction
    function confirmTransaction(uint index) public payable {
        // require(isUser(msg.sender), "require that you are a member of this dormitory" );
        // require(isEnough(), "require that the balance is enough to cover the bill");
        if(index < transactions.length) {
            if (msg.sender != transactions[index].user) {
                transactions[index].confirmUsers[transactions[index].confirmUsersNumber] = msg.sender;
                transactions[index].confirmUsersNumber ++;
                if(transactions[index].confirmUsersNumber == usersNumber - 1) {
                    transactions[index].user.transfer(transactions[index].money);
                    balance -= transactions[index].money;
                    bill -= transactions[index].money;
                }
            }
        }
    }
    
    //get the balance
    function getBalance() public view returns(uint) {
        return balance;
    }
    
    //determine whether the user has confirmed the transaction
    // function haveConfirmed(address user, uint index) public view returns(bool) {
    //     for (uint i = 0; i < 3; i++) {
    //         if (user == trasactions[index].confirmUsers[i]) return true;
    //     }
    //     return false;
    // }
    
    //get the number of trasactions one user needs to confirm
    // function getNumberOfTransactions() public view returns (uint) {
    //     require(isUser(msg.sender), "require that you are a member of this dormitory" );
    //     uint temp = 0;
    //     for (uint i = 0; i < trasactions.length; i++) {
    //         if (!haveConfirmed(msg.sender, i)) temp++;
    //     }
    //     return temp;
    // }
    
    //get the trasactions one user needs to confirm
    // function getTransactionsToConfirm() public returns (transaction[]) {
    //     require(isUser(msg.sender), "require that you are a member of this dormitory" );
    //     transaction[] temp;
    //     for (uint i = 0; i < trasactions.length; i++) {
    //         if(trasactions[i].user != msg.sender) {
    //             if (!haveConfirmed(msg.sender, i)) temp.push(trasactions[i]);
    //         }
    //     }
    //     return temp;
    // }
    
    //get users
    function getUsers() public view returns(address[4]) {
        return users;
    }
    
    //get commitedUsers
    function getCommitedUsers() public view returns(address[4]) {
        return commitedUsers;
    }
    
    //get the number of users
    function getNumberOfUsers() public view returns(uint) {
        return usersNumber;
    }
    
    //get the total number of trasactions
    function getTotalNumberOfTransactions() public view returns(uint) {
        return transactions.length;
    }
    
    //get the specific transaction
    function getTransactions(uint index) public view returns(uint, address, string, uint, uint, address[3]) {
        return (
        transactions[index].index,
        transactions[index].user,
        transactions[index].name,
        transactions[index].money,
        transactions[index].confirmUsersNumber,
        transactions[index].confirmUsers
        );
    }
    
    //get bill
    function getBill() public view returns(uint) {
        return bill;
    }

    //get administrator
    function getAdministrator() public view returns(address) {
        return administrator;
    }
    
}