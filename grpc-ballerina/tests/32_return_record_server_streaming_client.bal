// Copyright (c) 2021 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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
function testReceiveStreamingResponseFromReturnWithBasicAuth() {
    SampleMsg32 reqMsg = {name:"WSO2", id:2};
    HelloWorld32Client helloWorldEp = new("http://localhost:9122");

    var result = helloWorldEp->sayHello(reqMsg);
    if (result is Error) {
        test:assertFail("Error from Connector: " + result.message());
    } else {
        io:println("Connected successfully");
        SampleMsg32[] expectedResults = [
            {name: "WSO2", id: 0},
            {name: "Microsoft", id: 1},
            {name: "Facebook", id: 2},
            {name: "Google", id: 3}
        ];
        int count = 0;
        error? e = result.forEach(function(anydata value) {
            test:assertEquals(<SampleMsg32>value, expectedResults[count]);
            count += 1;
        });
        test:assertEquals(count, 4);
    }
}

public client class HelloWorld32Client {

    *AbstractClientEndpoint;

    private Client grpcClient;

    public isolated function init(string url, ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = checkpanic new(url, config);
        Error? result = self.grpcClient.initStub(self, ROOT_DESCRIPTOR_32, getDescriptorMap32());
    }

    isolated remote function sayHello(SampleMsg32 req) returns stream<anydata>|Error {

        return self.grpcClient->executeServerStreaming("HelloWorld32/sayHello", req);
    }

}
