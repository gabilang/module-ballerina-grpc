// Copyright (c) 2018 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/io;
import ballerina/test;

@test:Config {enable:true}
isolated function testUnarySecuredBlocking() {
    HelloWorld85Client helloWorld9BlockingEp = new ("https://localhost:9099", {
        secureSocket:{
            trustStore:{
               path: TRUSTSTORE_PATH,
               password: "ballerina"
            },
            keyStore: {
                path: KEYSTORE_PATH,
                password: "ballerina"
            },
            protocol: {
                name: "TLSv1.2",
                versions: ["TLSv1.2","TLSv1.1"]
            },
            certValidation : {
                enable: false
            },
            ocspStapling : false
        }
    });

    string|Error unionResp = helloWorld9BlockingEp->hello("WSO2");
    if (unionResp is Error) {
        test:assertFail(io:sprintf("Error from Connector: %s", unionResp.message()));
    } else {
        io:println("Client Got Response : ");
        io:println(unionResp);
        test:assertEquals(unionResp, "Hello WSO2");
    }
}

public client class HelloWorld85Client {

    *AbstractClientEndpoint;

    private Client grpcClient;

    public isolated function init(string url, ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = checkpanic new(url, config);
        checkpanic self.grpcClient.initStub(self, ROOT_DESCRIPTOR_9, getDescriptorMap9());
    }

    isolated remote function hello(string|ContextString req) returns (string|Error) {
        
        map<string|string[]> headers = {};
        string message;
        if (req is ContextString) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld85/hello", message, headers);
        [anydata, map<string|string[]>][result, _] = payload;
        return result.toString();
    }
    isolated remote function helloContext(string|ContextString req) returns (ContextString|Error) {
        
        map<string|string[]> headers = {};
        string message;
        if (req is ContextString) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld85/hello", message, headers);
        [anydata, map<string|string[]>][result, respHeaders] = payload;
        return {content: result.toString(), headers: respHeaders};
    }

}

