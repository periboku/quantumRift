const Web3 = require('web3'); // Assuming you have web3 installed using npm or yarn

const connectButton = document.getElementById('connectButton');
const accountAddress = document.getElementById('accountAddress');

connectButton.addEventListener('click', async () => {
    // Replace with the URL of your Ethereum node provider (e.g., Infura, Alchemy)
    const provider = new Web3.providers.HttpProvider('https://mainnet.infura.io/v3/YOUR_INFURA_PROJECT_ID');
    const web3 = new Web3(provider);

    try {
        const accounts = await ethereum.request({ method: 'eth_requestAccounts' });
        const connectedAccount = accounts[0];

        if (connectedAccount) {
            accountAddress.textContent = `Connected Account: ${connectedAccount}`;
            console.log('Connected account:', connectedAccount);

            // Example usage of web3: Get account balance
            const balance = await web3.eth.getBalance(connectedAccount);
            console.log('Account balance (wei):', balance);
            // Convert wei to ether for display purposes (assuming 18 decimals)
            const etherBalance = web3.utils.fromWei(balance, 'ether');
            console.log('Account balance (ether):', etherBalance);
        } else {
            console.log('MetaMask not connected or user declined connection');
        }
    } catch (error) {
        console.error('Error connecting to Ethereum node:', error);
    }
});
