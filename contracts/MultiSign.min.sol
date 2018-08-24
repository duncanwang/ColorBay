pragma solidity ^0.4.23;

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  /**
   * @dev Multiplies two numbers, throws on overflow.
   */
  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (a == 0) {
      return 0;
    }

    c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
   * @dev Integer division of two numbers, truncating the quotient.
   */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    // uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return a / b;
  }

  /**
   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
   */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
   * @dev Adds two numbers, throws on overflow.
   */
  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
    c = a + b;
    assert(c >= a);
    return c;
  }
}

interface ERC20 {
    function transfer(address to, uint256 value) external returns (bool);

    function balanceOf(address who) view external returns (uint256);
}

/**
 * @title MultiSign
 * @dev Allows multiple parties to agree on transactions before execution.
 * @author colorbay.org
 */
contract ColorbayMultiSign {

    using SafeMath for uint256;
    
    uint256 public MAX_OWNER_COUNT = 50;

    event Confirmation(address indexed sender, uint256 indexed transactionId);
    event Revocation(address indexed sender, uint256 indexed transactionId);
    event Submission(uint256 indexed transactionId);
    event Execution(uint256 indexed transactionId); 
    event ExecutionSuccess(uint256 indexed transactionId);
    event ExecutionFailure(uint256 indexed transactionId);
    event OwnerAddition(address indexed owner);
    event OwnerRemoval(address indexed owner);
    event RequirementChange(uint256 required);

    mapping (uint256 => Transaction) public transactions;
    mapping (uint256 => mapping(address => bool)) public confirmations;
    mapping (address => bool) public isOwner;
    address[] public owners;
    uint256 public required;
    uint256 public transactionCount;
    address public creator;

    ERC20 public token;

    struct Transaction {
        address destination;
        uint256 value;
        bool executed;
    }

    modifier onlyWallet() {
        require(msg.sender == address(this));
        _;
    }
    
    modifier onlyCreator() {
        require(msg.sender == creator);
        _;
    }    

    modifier ownerNotExists(address owner) {
        require(!isOwner[owner]);
        _;
    }

    modifier ownerExists(address owner) {
        require(isOwner[owner]);
        _;
    }

    modifier transactionExists(uint256 transactionId) {
        require(transactions[transactionId].destination != 0);
        _;
    }

    modifier confirmed(uint256 transactionId, address owner) {
        require(confirmations[transactionId][owner]);
        _;
    }

    modifier notConfirmed(uint256 transactionId, address owner) {
        require(!confirmations[transactionId][owner]);
        _;
    }

    modifier notExecuted(uint256 transactionId) {
        require(!transactions[transactionId].executed);
        _;
    }

    modifier notNull(address _address) {
        require(_address != address(0));
        _;
    }

    modifier validRequirement(uint256 ownerCount, uint256 _required) {
        require(ownerCount > 0 && ownerCount <= MAX_OWNER_COUNT && _required > 0 && _required <= ownerCount);
        _;
    }

    /**
     * @dev Contract constructor sets initial owners and required number of confirmations.
     * @param _owners List of initial owners.
     * @param _required Number of required confirmations.
     */
    constructor(address _token, address[] _owners, uint256 _required) public validRequirement(_owners.length, _required)
    {
        token = ERC20(_token);
        require(_owners.length <= 100);
        for (uint256 i=0; i<_owners.length; i++) {  
            require(!isOwner[_owners[i]] && _owners[i] != address(0));             
            isOwner[_owners[i]] = true;
        }
        owners = _owners;
        required = _required;
        creator = msg.sender;
    }

   

    /** 
     * @dev Allows to remove an owner. Transaction has to be sent by wallet.
     * @param owner Address of owner.
     */
    function removeOwner(address owner) public ownerExists(owner)
    {
        /*only owner can delete itself*/
        require(owner == msg.sender);
        
        isOwner[owner] = false;
        for (uint256 i=0; i<owners.length.sub(1); i++) {
            if (owners[i] == owner) {
                owners[i] = owners[owners.length.sub(1)];
                break;
            }
        }            
        owners.length = owners.length.sub(1);
        if (required > owners.length) {
            changeRequirement(owners.length);
        }            
        emit OwnerRemoval(owner);
    }
    
    /** 
     * @dev Withdraw the token remained to the constructor address.
     */
    function withdrawToken() public onlyCreator{
        if( 0 < token.balanceOf(address(this))) {
           token.transfer(creator, token.balanceOf(address(this)));
        }
    }    


    

    /** 
     * @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
     * @param _required Number of required confirmations.
     */
    function changeRequirement(uint256 _required) public validRequirement(owners.length, _required)
    {
        required = _required;
        emit RequirementChange(_required);
    }

    /** 
     * @dev Allows an owner to submit and confirm a transaction.
     * @param destination Transaction target address.
     * @param value Transaction ether value.
     * @return Returns transaction ID.
     */
    function submitTransaction(address destination, uint256 value) public returns (uint256 transactionId)
    {
        transactionId = addTransaction(destination, value);
        confirmTransaction(transactionId);
    }

    /** 
     * @dev Allows an owner to confirm a transaction.
     * @param transactionId Transaction ID.
     */
    function confirmTransaction(uint256 transactionId) public ownerExists(msg.sender) transactionExists(transactionId) notConfirmed(transactionId, msg.sender)
    {
        confirmations[transactionId][msg.sender] = true;
        emit Confirmation(msg.sender, transactionId);
        executeTransaction(transactionId);
    }

    /**  
     * @dev Allows an owner to revoke a confirmation for a transaction.
     * @param transactionId Transaction ID.
     */
    function revokeConfirmation(uint256 transactionId) public ownerExists(msg.sender) confirmed(transactionId, msg.sender) notExecuted(transactionId)
    {
        confirmations[transactionId][msg.sender] = false;
        emit Revocation(msg.sender, transactionId);
    }

    /** 
     * @dev Allows anyone to execute a confirmed transaction.
     * @param transactionId Transaction ID.
     */
    function executeTransaction(uint256 transactionId) public notExecuted(transactionId)
    {
        if (isConfirmed(transactionId)) {
            Transaction storage ta = transactions[transactionId];
            ta.executed = true;
            if(token.transfer(ta.destination, ta.value)) {
                emit ExecutionSuccess(transactionId);
            } else {
                emit ExecutionFailure(transactionId);
                ta.executed = false;
            }
        }
    }

    /** 
     * @dev Returns the confirmation status of a transaction.
     * @param transactionId Transaction ID.
     * @return Confirmation status.
     */
    function isConfirmed(uint256 transactionId) public view returns (bool)
    {
        uint256 count = 0;
        for (uint256 i=0; i<owners.length; i++) {
            if (confirmations[transactionId][owners[i]]) {
                count = count.add(1);
            }                
            if (count == required) {
                return true;
            }                
        }
    }

    /** 
     * @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
     * @param destination Transaction target address.
     * @param value Transaction ether value.
     * @return Returns transaction ID.
     */
    function addTransaction(address destination, uint256 value) internal notNull(destination) returns (uint256 transactionId)
    {
        transactionId = transactionCount;
        transactions[transactionId] = Transaction({
            destination: destination,
            value: value,
            executed: false
        });
        transactionCount = transactionCount.add(1);
        emit Submission(transactionId);
    }

    /** 
     * Web3 call functions
     * @dev Returns number of confirmations of a transaction.
     * @param transactionId Transaction ID.
     * @return Number of confirmations.
     */
    function getConfirmationCount(uint256 transactionId) public view returns (uint256 count)
    {
        for (uint256 i=0; i<owners.length; i++) {
            if (confirmations[transactionId][owners[i]]) {
                count = count.add(1);
            }
        }            
                
    }

    /** 
     * @dev Returns total number of transactions after filers are applied.
     * @param pending Include pending transactions.
     * @param executed Include executed transactions.
     * @return Total number of transactions after filters are applied.
     */
    function getTransactionCount(bool pending, bool executed) public view returns (uint256 count)
    {
        for (uint256 i=0; i<transactionCount; i++) {
            if (pending && !transactions[i].executed || executed && transactions[i].executed) {
                count = count.add(1);
            }
        }           
                
    }

    /** 
     * @dev Returns list of owners.
     * @return List of owner addresses.
     */
    function getOwners() public view returns (address[])
    {
        return owners;
    }

    /** 
     * @dev Returns array with owner addresses, which confirmed transaction.
     * @param transactionId Transaction ID.
     * @return Returns array of owner addresses.
     */
    function getConfirmations(uint256 transactionId) public view returns (address[] _confirmations)
    {
        address[] memory confirmationsTemp = new address[](owners.length);
        uint256 count = 0;
        for (uint256 i=0; i<owners.length; i++) {
            if (confirmations[transactionId][owners[i]]) {
                confirmationsTemp[count] = owners[i]; 
                count = count.add(1);
            }
        }            
        _confirmations = new address[](count);
        for (i=0; i<count; i++) {
            _confirmations[i] = confirmationsTemp[i];
        }

    }

    
    /** 
     * @dev Returns list of transaction IDs in defined range.
     * @param from Index start position of transaction array.
     * @param to Index end position of transaction array.
     * @param pending Include pending transactions.
     * @param executed Include executed transactions.
     * @return Returns array of transaction IDs.
     */
    function getTransactionIds(uint256 from, uint256 to, bool pending, bool executed) public view returns (uint256[] _transactionIds)
    {
        uint256[] memory transactionIdsTemp = new uint256[](transactionCount);
        uint256 count = 0;
        for (uint256 i=0; i<transactionCount; i++) {
            if (pending && !transactions[i].executed || executed && transactions[i].executed)
            {
                transactionIdsTemp[count] = i;
                count = count.add(1);
            }
        }            
        _transactionIds = new uint256[](to.sub(from));
        for (i=from; i<to; i++) {
            _transactionIds[i.sub(from)] = transactionIdsTemp[i];
        }
            
    }

}
