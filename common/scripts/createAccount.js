var StellarSdk = require('stellar-sdk');

var HORIZON_ENDPOINT = "http://localhost:8000/";//process.env.HORIZON_ENDPOINT;
var NETWORK_PASSPHRASE = "Standalone Network ; February 2017";//process.env.NETWORK_PASSPHRASE;
var rootAccount = "SC5O7VZUXDJ6JBDSZ74DSERXL7W3Y5LTOAMRF7RQRL3TAGAPS7LUVG3L";
var amount = process.argv[2] || "20";
var memo = "initial account creation";

StellarSdk.Network.use(new StellarSdk.Network(NETWORK_PASSPHRASE));
var opts = new StellarSdk.Config.setAllowHttp(true);
var server = new StellarSdk.Server(HORIZON_ENDPOINT, opts);
var sourceKeys = StellarSdk.Keypair.fromSecret(rootAccount)
var destinationKeys = StellarSdk.Keypair.random();

server.loadAccount(sourceKeys.publicKey())
    .then(function(sourceAccount) {
	var transaction = new StellarSdk.TransactionBuilder(sourceAccount)
	    .addOperation(StellarSdk.Operation.createAccount({
		destination: destinationKeys.publicKey(),
		startingBalance: amount
	    }))
	    .addMemo(StellarSdk.Memo.text(memo))
	    .build();
	transaction.sign(sourceKeys);
	return server.submitTransaction(transaction)
	    .then(function(result) {
		    console.log(JSON.stringify(result, null, 2));
		    var newAccount = {"publicKey": destinationKeys.publicKey(), "secretKey": destinationKeys.secret()};
		    console.log(JSON.stringify(newAccount, null, 2));
		
	    })
	    .catch(function(error) {
		console.log('An error occured:');
		console.log(error);
	    });
    })
    .catch(function(error) {
	console.error('Something went wrong!', error);
    });
