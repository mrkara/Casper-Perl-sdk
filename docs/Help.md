# Perl Casper SDK manual on classes and methods

## RPC Calls

The calling the RPC follow this sequence:

- Create the POST request with corresponding paramters for each methods

- Send the POST request to the Casper server (test net or main net or localhost) 

- Get the Json message back from the server. The message could either be error message or the json string representing the object need to retrieve. If you send wrong parameter, such as in "chain_get_state_root_hash" RPC call, if you send BlockIdentifier with too big block height (that does not exist) then you will get error message back from Casper server. If you send correct parameter, you will get expected json message for the data you need.

- Handle the data sent back from Casper server for the POST request. Depends on the RPC method call, the corresponding json data is sent back in type of [String:Value] form. The task of the SDK is to parse this json data and put in correct data type built for each RPC method.

## List of RPC methods:

1) [Get state root hash (chain_get_state_root_hash)](#i-get-state-root-hash)

2) [Get peer list (info_get_peers)](#ii-get-peers-list)

3) [Get Deploy (info_get_deploy)](#iii-get-deploy)

4) [Get Status (info_get_status)](#iv-get-status)

5) [GetBlockTransfersResult transfer (chain_get_block_transfers)](#v-get-block-transfers)

6) [Get Block (chain_get_block)](#vi-get-block)

7) [Get Era by switch block (chain_get_era_info_by_switch_block)](#vii-get-era-info-by-switch-block)

8) [Get Item (state_get_item)](#vii-get-item)

9) [Get Dictionary item (state_get_dictionary_item)](#ix-get-dictionaray-item)

10) [Get balance (state_get_balance)](#x-get-balance)

11) [Get Auction info (state_get_auction_info)](#xi-get-auction-info)

12) Put Deploy (account_put_deploy) 

### I. Get State Root Hash  

The task is done in file "GetStateRootHashRPC.pm" in folder "GetStateRootHash"

#### 1. Method declaration

```Perl
sub getStateRootHash
```

#### 2. Input & Output: 

The sample code for calling chain_get_state_root_hash RPC is done in the "GetStateRootHashTest.t" file under "t" folder of the SDK.
The procedure for calling the get state root hash is: 
First you need to instantiate an instance of the BlockIdentifier class (which declared in file "BlockIdentifier.pm" under folder "Common"). The BlockIdentifier object is used to set the input parameter for the chain_get_state_root_hash call.
When the parameter for the BlockIdentifier is set, the BlockIdentifier then generate the post parameter for sending to Casper server to get the state root hash back. The sending POST request is sent and handled within file "GetStateRootHashRPC.pm" in folder "GetStateRootHash". Then the state root hash is retrieved if the correct data for the POST request is used, otherwise there will be error object thrown. 

- Here are some examples of correct data to send:

	- *Set the BlockIdentifier with type of Hash and pass a correct block hash to the BlockIdentifier*

	- *Set the BlockIdentifier with type of Height and pass a correct block height to the BlockIdentifier*

- Here are some examples of incorrect data to send:

	- *Set the BlockIdentifier with type of Hash and pass a incorrect block hash to the BlockIdentifier*

	- *Set the BlockIdentifier with type of Height and pass a incorrect block height to the BlockIdentifier - for example the height is too big, bigger than the max current height of the block, or bigger than U64.max.*

Please refer to the "GetStateRootHashTest.t" under "t" folder to see the real example of how to generate the parameter with correct and incorrect data.

**In detail:**

**Input:** NSString represents the json parameter needed to send along with the POST method to Casper server. This parameter is build based on the BlockIdentifier.

When call this method to get the state root hash, you need to declare a BlockIdentifier object and then assign the height or hash or just none to the BlockIdentifier. Then the BlockIdentifier is transfer to the jsonString parameter. The whole sequence can be seen as the following code:
1. Declare a BlockIdentifier and assign its value
```Perl
my $bi = new Common::BlockIdentifier();
# Call with block hash
$bi->setBlockType("hash");
$bi->setBlockHash("d16cb633eea197fec519aee2cfe050fe9a3b7e390642ccae8366455cc91c822e");

# or you can set the block attribute like this

$bi->setBlockType("height");
$bi->setBlockHeight("1234");

or like this

$bi->setBlockType("none");
   
# then you generate the jsonString to call the generatePostParam function
my $postParamStr = $bi->generatePostParam($Common::ConstValues::RPC_GET_STATE_ROOT_HASH);
```
2. Use the $postParamStr to call the function:

```Perl
my $getStateRootHashRPC = new GetStateRootHash::GetStateRootHashRPC();
my $stateRootHash = $getStateRootHashRPC->getStateRootHash($postParamStr);
```

**Output:** the state root hash is retrieved if the correct data for the POST request is used, otherwise there will be error object thrown. 

This process is done within the function "sub getStateRootHash" of the class "GetStateRootHash::GetStateRootHashRPC" (declare in file GetStateRootHashRPC.pm under folder lib/GetStateRootHash).

### II. Get Peers List  

The task is done in file "GetPeerPRC.pm" and "GetPeerResult.pm"

#### 1. Method declaration

From file "GetPeerPRC.pm" call this method

```Perl
sub getPeers
```

This method call other method from file "GetPeerResult.pm" to get the state root hash or handle the error retrieved from the http response.

```Perl
sub fromJsonObjectToGetPeersResult
```

#### 2. Input & Output: 

In this function of file "GetPeerPRC.pm"

```Perl
sub getPeers
```

- **Input:** NSString represents the json parameter needed to send along with the POST method to Casper server. This string is just simple as:

```Perl
{"params" : [],"id" : 1,"method":"info_get_peers","jsonrpc" : "2.0"}
```

The retrieve of PeerEntry List is done with this function:

```Perl
GetPeers::GetPeersResult->fromJsonObjectToGetPeersResult($json)
```
in which $json is the $json data retrieved from the http response.

- **Output:** List of peer defined in class GetPeersResult, which contain a list of PeerEntry - a class contain of nodeId and address.

### III. Get Deploy 

#### 1. Method declaration

The call for Get Deploy RPC method is done through this function in "GetDeployRPC.pm" file under folder "GetDeploy"

```Perl
sub getDeployResult
```

From this the GetDeployResult is retrieved through this function, defined in "GetDeployResult.m" file

```Perl
GetDeploy::GetDeployResult->fromJsonObjectToGetDeployResult($json) 
```

#### 2. Input & Output: 

* In this function of file "GetDeployRPC.pm"

```Perl
sub getDeployResult
```

- **Input:** is the string of parameter sent to Http Post request to the RPC method, which in form of

```Perl
{"id" : 1,"method" : "info_get_deploy","params" : {"deploy_hash" : "6e74f836d7b10dd5db7430497e106ddf56e30afee993dd29b85a91c1cd903583"},"jsonrpc" : "2.0"}
```
To generate such string, you need to use GetDeployParams class, which declared in file "GetDeployParams.pm"

Instantiate the GetDeployParams, then assign the deploy_hash to the object and use function generatePostParam to generate such parameter string like above.

Sample  code for this process

```Perl
my $getDeployParams = new GetDeploy::GetDeployParams();
$getDeployParams->setDeployHash("55968ee1a0a7bb5d03505cd50996b4366af705692645e54125184a885c8a65aa");
my $paramStr = $getDeployParams->generateParameterStr();
my $getDeployRPC = new GetDeploy::GetDeployRPC();
my $getDeployResult = $getDeployRPC->getDeployResult($paramStr);
```

- **Output:** The ouput is handler in HttpHandler class and then pass to fromJsonObjectToGetDeployResult function, described below:

* For function 

```Perl
sub fromJsonObjectToGetDeployResult 
```

- **Input:** The Json object represents the GetDeployResult object. This Json object is returned from the POST method when call the RPC method. Information is sent back as JSON data and from that JSON data GetDeployResult is taken to pass to the function to get the Deploy information.

- **Output:** The GetDeployResult which contains all information of the Deploy. From this result you can retrieve information of Deploy hash, Deploy header, Deploy session, payment, ExecutionResults.

### IV. Get Status

#### 1. Method declaration

The call for Get Status RPC method is done through this function in file "GetStatusResultRPC.pm" in folder "GetStatus":

```Perl
sub getStatus
```

From this the GetStatusResult is retrieved through this function in file "GetStatusResult.m" in the same folder of "GetStatus":

```Perl
sub fromJsonObjectToGetStatusResult
```

#### 2. Input & Output: 

* In this function in file "GetStatusResultRPC.pm":

```Perl
sub getStatus
```

- **Input:** a JsonString of value 
```Perl
{"params" : [],"id" : 1,"method":"info_get_status","jsonrpc" : "2.0"}
```

- **Output:** The ouput is handler in HttpHandler class and then pass to fromJsonDictToGetStatusResult function, described below:

* In this function in file "GetStatusResult.pm":

```Perl
sub fromJsonObjectToGetStatusResult
```

- **Input:** The Json object represents the GetStatusResult object. This Json object is returned from the POST method when call the RPC method. Information is sent back as JSON data and from that JSON data the GetStatusResult object is taken through this function.

- **Output:** The GetStatusResult which contains all information of the status. From this result you can retrieve information such as: api_version,chainspec_name,starting_state_root_hash,peers,last_added_block_info...

### V. Get Block Transfers

#### 1. Method declaration

The call for Get Block Transfers RPC method is done through this function in "GetBlockTransfersRPC.pm" file under folder "GetBlockTransfers":

```Perl
sub getBlockTransfers
```

From this the GetBlockTransfersResult is retrieved through this function, in "GetBlockTransfersResult.pm" file, which is also in folder "GetBlockTransfers":

```Perl
sub fromJsonObjectToGetBlockTransfersResult
```

#### 2. Input & Output: 

* In this function in file "GetBlockTransfersRPC.pm":

```Perl
sub getBlockTransfers
```

- **Input:** a JsonString of such value:

```Perl
{"method" : "chain_get_block_transfers","id" : 1,"params" : {"block_identifier" : {"Hash" :"d16cb633eea197fec519aee2cfe050fe9a3b7e390642ccae8366455cc91c822e"}},"jsonrpc" : "2.0"}
```

To generate such string, you need to use an object of type BlockIdentifier class, which declared in file "BlockIdentifier.pm" under folder "Common"

Instantiate the BlockIdentifier, then assign the block with block hash or block height or just assign nothing to the object and use function "generatePostParam" of the "BlockIdentifier" class to generate such parameter string like above.
The whole sequence can be seen as the following code:
1. Declare a BlockIdentifier and assign its value
```Perl
my $bi = new Common::BlockIdentifier();
# Call with block hash
$bi->setBlockType("hash");
$bi->setBlockHash("d16cb633eea197fec519aee2cfe050fe9a3b7e390642ccae8366455cc91c822e");

# or you can set the block attribute like this

$bi->setBlockType("height");
$bi->setBlockHeight("1234");

or like this

$bi->setBlockType("none");
   
# then you generate the jsonString to call the generatePostParam function
my $postParamStr = $bi->generatePostParam($Common::ConstValues::RPC_GET_BLOCK_TRANSFERS);
```
2. Use the $postParamStr to call the function:

```Perl
my $getBlockTransfers = new GetBlockTransfers::GetBlockTransfersRPC();
my $getBTResult = $getBlockTransfers->getBlockTransfers($postParamStr);
```

**Output:** The result of the Post request for the RPC method is a Json string data back, which can represents the error or the GetBlockTransfersResult object.

The code for this process is in function getBlockTransfers of file "GetBlockTransferRPC.pm" like this:

```Perl
my $errorCode = $decoded->{'error'}{'code'};
if($errorCode) {
	my $errorException = new Common::ErrorException();
	$errorException->setErrorCode($errorCode);
	$errorException->setErrorMessage($decoded->{'error'}{'message'});
	return $errorException;
} else {
   	my $ret = GetBlockTransfers::GetBlockTransfersResult->fromJsonObjectToGetBlockTransfersResult($decoded->{'result'});
	return $ret;
}
```
* For this function in file "GetBlockTransfersResult.pm":

```Perl
sub fromJsonObjectToGetBlockTransfersResult
```

**Input:** The Json object represents the GetBlockTransfersResult object. This Json object is returned from the POST method when call the RPC method. Information is sent back as JSON data and from that JSON data the GetBlockTransfersResult is taken.

**Output:** The GetBlockTransfersResult which contains all information of the Block Transfers. From this result you can retrieve information such as: api_version,block_hash, list of transfers. (Transfer is wrap in class Transfer.h and all information of Transfer can retrieve from this result).

### VI. Get Block 

#### 1. Method declaration

The call for Get Block Transfers RPC method is done through this function in "GetBlockRPC.pm" file under folder "GetBlock":

```Perl
sub getBlock
```

From this the GetBlockResult is retrieved through this function in file "GetBlockResult.pm" under the same folder "GetBlock":

```Perl
sub fromJsonObjectToGetBlockResult
```

#### 2. Input & Output: 

* For function in file "GetBlockRPC.pm":

```Perl
sub getBlock
}
```

**Input:** a JsonString of such value:
```Perl
{"method" : "chain_get_block","id" : 1,"params" : {"block_identifier" : {"Hash" :"d16cb633eea197fec519aee2cfe050fe9a3b7e390642ccae8366455cc91c822e"}},"jsonrpc" : "2.0"}
```

To generate such string, you need to use an object of type BlockIdentifier class, which declared in file "BlockIdentifier.pm" under folder "Common"

Instantiate the BlockIdentifier, then assign the block with block hash or block height or just assign nothing to the object and use function "generatePostParam" of the "BlockIdentifier" class to generate such parameter string like above.
The whole sequence can be seen as the following code:
1. Declare a BlockIdentifier and assign its value
```Perl
my $bi = new Common::BlockIdentifier();
# Call with block hash
$bi->setBlockType("hash");
$bi->setBlockHash("d16cb633eea197fec519aee2cfe050fe9a3b7e390642ccae8366455cc91c822e");

# or you can set the block attribute like this

$bi->setBlockType("height");
$bi->setBlockHeight("1234");

or like this

$bi->setBlockType("none");
   
# then you generate the jsonString to call the generatePostParam function
my $postParamStr = $bi->generatePostParam($Common::ConstValues::RPC_GET_BLOCK);
```

**Output:** The result of the Post request for the RPC method is a Json string data back, which can represents the error or the GetBlockTransfersResult object.

The code for this process is in function getBlockTransfers of file "GetBlockTransferRPC.pm" like this:

```Perl
my $errorCode = $decoded->{'error'}{'code'};
if($errorCode) {
	my $errorException = new Common::ErrorException();
	$errorException->setErrorCode($errorCode);
	$errorException->setErrorMessage($decoded->{'error'}{'message'});
	return $errorException;
} else {
   	my $ret = GetBlockTransfers::GetBlockTransfersResult->fromJsonObjectToGetBlockTransfersResult($decoded->{'result'});
	return $ret;
}
```
* For this function in file "GetBlockResult.pm":

```Perl
sub fromJsonObjectToGetBlockResult
```

**Input:** The Json object represents the GetBlockResult object. This Json object is returned from the POST method when call the RPC method. Information is sent back as JSON data and from that JSON data the GetBlockResult is taken to pass to the function to get the block information.

**Output:** The GetBlockResult which contains all information of the block. From this result you can retrieve information such as: api_version,JsonBlock object(in which you can retrieve information such as: blockHash, JsonBlockHeader,JsonBlockBody, list of proof)

### VII. Get Era Info By Switch Block

#### 1. Method declaration

The call for Get Era Info RPC method is done through this function in "GetEraInfoBySwitchBlockRPC.pm" file under folder "GetEraInfoBySwitchBlock"

```Perl
sub getEraInfo 
```

Fro this the GetEraInfoResult is retrieved through this function, also in "GetEraInfoResult.m" file

```Perl
sub fromJsonToGetEraInfoResult
```

#### 2. Input & Output: 

* For function in file "GetEraInfoBySwitchBlockRPC.pm":

```Perl
sub getEraInfo
```

**Input:** a JsonString of such value:
```Perl
{"method" : "chain_get_era_info_by_switch_block","id" : 1,"params" : {"block_identifier" : {"Hash" :"d16cb633eea197fec519aee2cfe050fe9a3b7e390642ccae8366455cc91c822e"}},"jsonrpc" : "2.0"}
```

To generate such string, you need to use an object of type BlockIdentifier class, which declared in file "BlockIdentifier.pm" under folder "Common"

Instantiate the BlockIdentifier, then assign the block with block hash or block height or just assign nothing to the object and use function "generatePostParam" of the "BlockIdentifier" class to generate such parameter string like above.
The whole sequence can be seen as the following code:
1. Declare a BlockIdentifier and assign its value
```Perl
my $bi = new Common::BlockIdentifier();
# Call with block hash
$bi->setBlockType("hash");
$bi->setBlockHash("d16cb633eea197fec519aee2cfe050fe9a3b7e390642ccae8366455cc91c822e");

# or you can set the block attribute like this

$bi->setBlockType("height");
$bi->setBlockHeight("1234");

or like this

$bi->setBlockType("none");
   
# then you generate the jsonString to call the generatePostParam function
my $postParamStr = $bi->generatePostParam($Common::ConstValues::RPC_GET_BLOCK);
```

**Output:** The result of the Post request for the RPC method is a Json string data back, which can represents the error or the GetEraInfoResult object.

The code for this process is in function GetEraInfoResult of file "GetEraInfoBySwitchBlockRPC.pm" like this:

```Perl
my $errorCode = $decoded->{'error'}{'code'};
if($errorCode) {
	my $errorException = new Common::ErrorException();
	$errorException->setErrorCode($errorCode);
	$errorException->setErrorMessage($decoded->{'error'}{'message'});
	return $errorException;
} else {
   	my $ret = GetEraInfoBySwitchBlock::GetEraInfoResult->fromJsonToGetEraInfoResult($decoded->{'result'});
	return $ret;
}
```
* For this function in file "GetEraInfoResult.pm" under folder "GetEraInfoBySwitchBlock":

```Perl
sub fromJsonToGetEraInfoResult
```

**Input:** The Json object represents the GetEraInfoResult object. This Json object is returned from the POST method when call the RPC method. Information is sent back as JSON data and from that the JSON data the GetEraInfoResult is retrieved.

**Output:** The GetEraInfoResult which contains all information of the era info. From this result you can retrieve information such as: api_version, era_summary (in which you can retrieve information such as: block_hash, era_id, state_root_hash, merkle_proof, stored_value).


### VII. Get Item

#### 1. Method declaration

The call for Get Item RPC method is done through this function in file "GetItemRPC.pm" under folder "GetItem":

```Perl
sub getItem
```

From this the GetItemResult is retrieved through this function in file "GetItemResult.pm", also under folder "GetItem": 

```Perl
sub fromJsonToGetItemResult
```

#### 2. Input & Output: 

* For this function in file "GetItemRPC.pm":

```Perl
sub getItem
```

**Input:** a JsonString of such value:
```Perl
{"method" : "state_get_item","id" : 1,"params" :{"state_root_hash" : "d360e2755f7cee816cce3f0eeb2000dfa03113769743ae5481816f3983d5f228","key":"withdraw-df067278a61946b1b1f784d16e28336ae79f48cf692b13f6e40af9c7eadb2fb1","path":[]},"jsonrpc" : "2.0"}
```

To generate such string, you need to use an object of type GetItemParams class, which declared in file "GetItemParams.pm" under folder "GetItem"

Instantiate the GetItemParams, then assign the GetItemParams object with state_root_hash, key, and path, then use function "generateParameterStr" of the "GetItemParams" class to generate such parameter string like above.

Sample  code for this process:

```Perl
my $getItemRPC = new GetItem::GetItemRPC();
my $getItemParams = new GetItem::GetItemParams();
$getItemParams->setStateRootHash("340a09b06bae99d868c68111b691c70d9d5a253c0f2fd7ee257a04a198d3818e");
$getItemParams->setKey("uref-ba620eee2b06c6df4cd8da58dd5c5aa6d42f3a502de61bb06dc70b164eee4119-007");
my $paramStr = $getItemParams->generateParameterStr();
my $getItemResult = $getItemRPC->getItem($paramStr);
```

**Output:** The result of the Post request for the RPC method is a Json string data back, which can represents the error or the GetEraInfoResult object.

The code for this process is in function getItem of file "GetItemRPC.pm" like this:

```Perl
my $d = $response->decoded_content;
my $decoded = decode_json($d);
my $errorCode = $decoded->{'error'}{'code'};
if($errorCode) {
	my $errorException = new Common::ErrorException();
	$errorException->setErrorCode($errorCode);
	$errorException->setErrorMessage($decoded->{'error'}{'message'});
	return $errorException;
} else {
   	my $ret = GetItem::GetItemResult->fromJsonToGetItemResult($decoded->{'result'});
	return $ret;
}
```

* For this function in file "GetItemResult.pm":

```Perl
sub fromJsonToGetItemResult
```

**Input:** The Json object represents the GetItemResult object. This Json is returned from the POST method when call the RPC method. Information is sent back as JSON data and from that JSON data the GetItemResult is retrieved.

**Output:** The GetItemResult which contains all information of the item. From this result you can retrieve information such as: api_version,merkle_proof, stored_value.

### IX. Get Dictionaray Item

#### 1. Method declaration

The call for Get Dictionary Item RPC method is done through this function in "GetDictionaryItemRPC.pm" file under "GetDictionaryItem" folder:

```Perl
sub getDictionaryItem
```

From this the GetDictionaryItemResult is retrieved through this function in "GetDictionaryItemResult.pm" file, also under "GetDictionaryItem" folder:

```Perl
sub fromJsonToGetDictionaryItemResult
```

#### 2. Input & Output: 

* For this function in file "GetDictionaryItemRPC.pm": 

```Perl
sub getDictionaryItem
```

**Input:** a JsonString of such value:
```Perl
{"method" : "state_get_dictionary_item","id" : 1,"params" :{"state_root_hash" : "146b860f82359ced6e801cbad31015b5a9f9eb147ab2a449fd5cdb950e961ca8","dictionary_identifier":{"AccountNamedKey":{"dictionary_name":"dict_name","key":"account-hash-ad7e091267d82c3b9ed1987cb780a005a550e6b3d1ca333b743e2dba70680877","dictionary_item_key":"abc_name"}}},"jsonrpc" : "2.0"}
```

To generate such string, you need to use an object of type GetDictionaryItemParams class, which declared in file "GetDictionaryItemParams.pm" under folder "GetDictionaryItem"

Instantiate the GetDictionaryItemParams, then assign the GetDictionaryItemParams object with state_root_hash and an DictionaryIdentifier value.
The DictionaryIdentifier can be 1 among 4 possible classes defined in folder "DictionaryIdentifierEnum".
When the state_root_hash and DictionaryIdentifier value are sets, use function "toJsonString" of the "GetDictionaryItemParams" class to generate such parameter string like above.

Sample  code for this process, with DictionaryIdentifier of type AccountNamedKey

```Perl
my $getDIRPC = new GetDictionaryItem::GetDictionaryItemRPC();
my $getDIParams = new GetDictionaryItem::GetDictionaryItemParams();
my $diANK = new GetDictionaryItem::DIAccountNamedKey();
$diANK->setKey("account-hash-ad7e091267d82c3b9ed1987cb780a005a550e6b3d1ca333b743e2dba70680877");
$diANK->setDictionaryName("dict_name");
$diANK->setDictionaryItemKey("abc_name");
my $di = new GetDictionaryItem::DictionaryIdentifier();
$di->setItsType("AccountNamedKey");
$di->setItsValue($diANK);
$getDIParams->setStateRootHash("146b860f82359ced6e801cbad31015b5a9f9eb147ab2a449fd5cdb950e961ca8");
$getDIParams->setDictionaryIdentifier($di);
my $paramStr = $getDIParams->generateParameterStr();
my $getDIResult = $getDIRPC->getDictionaryItem($paramStr);
```

**Output:** The result of the Post request for the RPC method is a Json string data back, which can represents the error or the GetEraInfoResult object.

The code for this process is in function getDictionaryItem of file "GetDictionaryItemRPC.pm" like this:

```Perl
my $d = $response->decoded_content;
my $decoded = decode_json($d);
my $errorCode = $decoded->{'error'}{'code'};
if($errorCode) {
	my $errorException = new Common::ErrorException();
	$errorException->setErrorCode($errorCode);
	$errorException->setErrorMessage($decoded->{'error'}{'message'});
	return $errorException;
} else {
    	my $ret = GetDictionaryItem::GetDictionaryItemResult->fromJsonToGetDictionaryItemResult($decoded->{'result'});
	return $ret;
}
```

* For this function in file "GetDictionaryItemResult.pm": 

```Perl
sub fromJsonToGetDictionaryItemResult 
```

**Input:** The Json object represents the GetDictionaryItemResult object. This NSDictionaray is returned from the POST method when call the RPC method. Information is sent back as JSON data and from that JSON data the GetDictionaryItemResult is retrieved.

**Output:** The GetDictionaryItemResult which contains all information of the dictionary item. From this result you can retrieve information such as: api_version,dictionary_key, merkle_proof,stored_value.

### X. Get Balance

#### 1. Method declaration

The call for Get Balance RPC method is done through this function in "GetBalanceResultRPC.pm" file under folder "GetBalance":

```Perl
sub getBalance
```

From this the GetBalanceResult is retrieved through this function, in "GetBalanceResult.pm" file, also under folder "GetBalance":

```Perl
sub fromJsonToGetBalanceResult
```

#### 2. Input & Output: 

* For this function in file "GetBalanceResultRPC.pm":  

```Perl
sub getBalance
```

**Input:** a JsonString of such value:
```Perl
{"method" : "state_get_balance","id" : 1,"params" :{"state_root_hash" : "8b463b56f2d124f43e7c157e602e31d5d2d5009659de7f1e79afbd238cbaa189","purse_uref":"uref-be1dc0fd639a3255c1e3e5e2aa699df66171e40fa9450688c5d718b470e057c6-007"},"jsonrpc" : "2.0"}
```

To generate such string, you need to use an object of type GetBalanceParams class, which declared in file "GetBalanceParams.pm" under folder "GetBalance".

Instantiate the GetBalanceParams, then assign the GetBalanceParams with state_root_hash and purse_uref then use function "generateParameterStr" of the "GetBalanceParams" class to generate such parameter string like above.

Sample  code for this process

```Perl
my $rpc = new GetBalance::GetBalanceResultRPC();
my $params = new GetBalance::GetBalanceParams();
$params->setStateRootHash("8b463b56f2d124f43e7c157e602e31d5d2d5009659de7f1e79afbd238cbaa189");
$params->setPurseUref("uref-be1dc0fd639a3255c1e3e5e2aa699df66171e40fa9450688c5d718b470e057c6-007");
my $paramStr = $params->generateParameterStr();
my $result = $rpc->getBalance($paramStr);
```

**Output:** The result of the Post request for the RPC method is a Json string data back, which can represents the error or the GetBalanceResult object.

The code for this process is in function getBalance of file "GetBalanceResultRPC.pm" like this:

```Perl
my $d = $response->decoded_content;
my $decoded = decode_json($d);
my $errorCode = $decoded->{'error'}{'code'};
if($errorCode) {
	my $errorException = new Common::ErrorException();
	$errorException->setErrorCode($errorCode);
	$errorException->setErrorMessage($decoded->{'error'}{'message'});
	return $errorException;
} else {
    	my $ret = GetBalance::GetBalanceResult->fromJsonToGetBalanceResult($decoded->{'result'});
	return $ret;
}
```

* For this function in file "GetBalanceResult.pm": 
```Perl
sub fromJsonToGetBalanceResult
```

**Input:** The Json object represents the GetBalanceResult object. This Json is returned from the POST method when call the RPC method. Information is sent back as JSON data and from that JSON data the GetBalanceResult is taken.

**Output:** The GetBalanceResult which contains all information of the balance. From this result you can retrieve information such as: api_version,balance_value, merkle_proof.

### XI. Get Auction Info

#### 1. Method declaration

The call for Get Auction RPC method is done through this function in "GetAuctionInfoRPC.pm" file under folder "GetAuction":

```Perl
sub getAuction
```

From this the GetAuctionInfoResult is retrieved through this function in "GetAuctionInfoResult.pm" file under folder "GetAuction":

```Perl
sub fromJsonToGetItemResult
```

#### 2. Input & Output: 

* For this function in file "GetAuctionInfoRPC.pm": 

```Perl
sub getAuction
```

**Input:** a JsonString of such value:
```Perl
{"method" : "state_get_auction_info","id" : 1,"params" : {"block_identifier" : {"Hash" :"d16cb633eea197fec519aee2cfe050fe9a3b7e390642ccae8366455cc91c822e"}},"jsonrpc" : "2.0"}
```

To generate such string, you need to use an object of type BlockIdentifier class, which declared in file "BlockIdentifier.pm" under folder "Common"

Instantiate the BlockIdentifier, then assign the block with block hash or block height or just assign nothing to the object and use function "generatePostParam" of the "BlockIdentifier" class to generate such parameter string like above.
The whole sequence can be seen as the following code:
1. Declare a BlockIdentifier and assign its value
```Perl
my $bi = new Common::BlockIdentifier();
# Call with block hash
$bi->setBlockType("hash");
$bi->setBlockHash("d16cb633eea197fec519aee2cfe050fe9a3b7e390642ccae8366455cc91c822e");

# or you can set the block attribute like this

$bi->setBlockType("height");
$bi->setBlockHeight("1234");

or like this

$bi->setBlockType("none");
   
# then you generate the jsonString to call the generatePostParam function
my $postParamStr = $bi->generatePostParam($Common::ConstValues::RPC_GET_AUCTION);
```

**Output:** The result of the Post request for the RPC method is a Json string data back, which can represents the error or the GetAuctionInfoResult object.

The code for this process is in function getAuction of file "GetAuctionInfoRPC.pm" like this:

```Perl
my $d = $response->decoded_content;
my $decoded = decode_json($d);
my $errorCode = $decoded->{'error'}{'code'};
if($errorCode) {
	my $errorException = new Common::ErrorException();
	$errorException->setErrorCode($errorCode);
	$errorException->setErrorMessage($decoded->{'error'}{'message'});
	return $errorException;
} else {
    	my $ret = GetAuction::GetAuctionInfoResult->fromJsonToGetItemResult($decoded->{'result'});
	return $ret;
}
```

* For this function in file "GetAuctionInfoResult.pm":

```Perl
sub fromJsonToGetItemResult 
```

**Input:** The Json object represents the GetAuctionInfoResult object. This Json is returned from the POST method when call the RPC method. Information is sent back as JSON data and from that JSON data the GetAuctionInfoResult is taken.

**Output:** The GetAuctionInfoResult which contains all information of the aunction. From this result you can retrieve information such as: api_version,auction_state (in which you can retrieve information such as state_root_hash, block_height, list of JsonEraValidators).
