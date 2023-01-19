// Connect to the Ethereum network
if (window.ethereum) {
    window.web3 = new Web3(window.ethereum);
    try {
      // Request account access
      await window.ethereum.enable();
    } catch (error) {
      // User denied account access...
    }
  }
  // Legacy dapp browsers...
  else if (window.web3) {
    window.web3 = new Web3(web3.currentProvider);
    // Acccounts always exposed
  }
  // Non-dapp browsers...
  else {
    console.log("Non-Ethereum browser detected. You should consider trying MetaMask!");
  }
  
  // Contract ABI and address
  const abi = [ABI of the smart contract];
  const contractAddress = "address of the smart contract";
  
  // Create a new contract object
  const contract = new web3.eth.Contract(abi, contractAddress);
  
  // Deposit Tokens
  async function depositTokens(amount) {
    // Check the amount is greater than 0
    if (amount <= 0) {
      alert("You need to deposit USDC");
      return;
    }
    // Get the current account
    const account = await web3.eth.getAccounts();
    // Deposit the tokens
    contract.methods.depositTokens(amount).send({ from: account[0] })
      .then(() => {
        alert("Deposit Successful!");
      })
      .catch((error) => {
        console.error(error);
      });
  }
  
  // Withdraw Tokens
  async function withdrawalTokens(amount) {
    // Get the current account
    const account = await web3.eth.getAccounts();
    // Withdraw the tokens
    contract.methods.withdrawalTokens(amount).send({ from: account[0] })
      .then(() => {
        alert("Withdrawal Successful!");
      })
      .catch((error) => {
        console.error(error);
      });
  }
  