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

final OneofFieldServiceClient blockingEp = new("http://localhost:9105");
const string ERROR_MESSAGE = "Expected response value type not received";

type Response1Typedesc typedesc<Response1>;
type ZZZTypedesc typedesc<ZZZ>;

@test:Config {enable:true}
function testOneofFieldValue() {
    Request1 request = {first_name:"Sam", age:31};
    var result = blockingEp->hello(request);
    if (result is Error) {
         test:assertFail(io:sprintf("Error from Connector: %s ", result.message()));
    } else {
        Response1 resp = {message:""};
        [resp, _] = result;

        test:assertEquals(resp.message, "Hello Sam");
    }
}

@test:Config {enable:true}
function testDoubleFieldValue() {
    ZZZ zzz = {one_a:1.7976931348623157E308};
    var result = blockingEp->testOneofField(zzz);
    if (result is Error) {
         test:assertFail(io:sprintf("Error from Connector: %s ", result.message()));
    } else {
        ZZZ resp;
        [resp, _] = result;
        test:assertEquals(resp?.one_a.toString(), "1.7976931348623157E308");
    }
}

@test:Config {enable:true}
function testFloatFieldValue() {
    ZZZ zzz = {one_b:3.4028235E38};
    var result = blockingEp->testOneofField(zzz);
    if (result is Error) {
         test:assertFail(io:sprintf("Error from Connector: %s ", result.message()));
    } else {
        ZZZ resp;
        [resp, _] = result;
        test:assertEquals(resp?.one_b.toString(), "3.4028235E38");
    }
}

@test:Config {enable:true}
function testInt64FieldValue() {
    ZZZ zzz = {one_c:-9223372036854775808};
    var result = blockingEp->testOneofField(zzz);
    if (result is Error) {
         test:assertFail(io:sprintf("Error from Connector: %s ", result.message()));
    } else {
        ZZZ resp;
        [resp, _] = result;
        test:assertEquals(resp?.one_c.toString(), "-9223372036854775808");
    }
}

@test:Config {enable:true}
function testUInt64FieldValue() {
    ZZZ zzz = {one_d:9223372036854775807};
    var result = blockingEp->testOneofField(zzz);
    if (result is Error) {
         test:assertFail(io:sprintf("Error from Connector: %s ", result.message()));
    } else {
        ZZZ resp;
        [resp, _] = result;
        test:assertEquals(resp?.one_d.toString(), "9223372036854775807");
    }
}

@test:Config {enable:true}
function testInt32FieldValue() {
    ZZZ zzz = {one_e:-2147483648};
    var result = blockingEp->testOneofField(zzz);
    if (result is Error) {
         test:assertFail(io:sprintf("Error from Connector: %s ", result.message()));
    } else {
        ZZZ resp;
        [resp, _] = result;
        test:assertEquals(resp?.one_e.toString(), "-2147483648");
    }
}

@test:Config {enable:true}
function testFixed64FieldValue() {
    ZZZ zzz = {one_f:9223372036854775807};
    var result = blockingEp->testOneofField(zzz);
    if (result is Error) {
         test:assertFail(io:sprintf("Error from Connector: %s ", result.message()));
    } else {
        ZZZ resp;
        [resp, _] = result;
        test:assertEquals(resp?.one_f.toString(), "9223372036854775807");
    }
}

@test:Config {enable:true}
function testFixed32FieldValue() {
    ZZZ zzz = {one_g:2147483647};
    var result = blockingEp->testOneofField(zzz);
    if (result is Error) {
         test:assertFail(io:sprintf("Error from Connector: %s ", result.message()));
    } else {
        ZZZ resp;
        [resp, _] = result;
        test:assertEquals(resp?.one_g.toString(), "2147483647");
    }
}

@test:Config {enable:true}
function testBolFieldValue() {
    ZZZ zzz = {one_h:true};
    var result = blockingEp->testOneofField(zzz);
    if (result is Error) {
         test:assertFail(io:sprintf("Error from Connector: %s ", result.message()));
    } else {
        ZZZ resp;
        [resp, _] = result;
        test:assertEquals(resp?.one_h.toString(), "true");
    }
}

@test:Config {enable:true}
function testStringFieldValue() {
    ZZZ zzz = {one_i:"Testing"};
    var result = blockingEp->testOneofField(zzz);
    if (result is Error) {
         test:assertFail(io:sprintf("Error from Connector: %s ", result.message()));
    } else {
        ZZZ resp;
        [resp, _] = result;
        test:assertEquals(resp?.one_i.toString(), "Testing");
    }
}

@test:Config {enable:true}
function testMessageFieldValue() {
    AAA aaa = {aaa: "Testing"};
    ZZZ zzz = {one_j:aaa};
    var result = blockingEp->testOneofField(zzz);
    if (result is Error) {
         test:assertFail(io:sprintf("Error from Connector: %s ", result.message()));
    } else {
        ZZZ resp;
        [resp, _] = result;
        test:assertEquals(resp?.one_j?.aaa.toString(), "Testing");
    }
}

@test:Config {enable:true}
function testBytesFieldValue() {
    string statement = "Lion in Town.";
    byte[] bytes = statement.toBytes();
    ZZZ zzz = {one_k:bytes};
    var result = blockingEp->testOneofField(zzz);
    if (result is Error) {
         test:assertFail(io:sprintf("Error from Connector: %s ", result.message()));
    } else {
        ZZZ resp;
        [resp, _] = result;
        boolean bResp = resp?.one_k == bytes;
        test:assertEquals(bResp.toString(), "true");
    }
}

public client class OneofFieldServiceClient {

    *AbstractClientEndpoint;

    private Client grpcClient;

    public isolated function init(string url, ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = checkpanic new(url, config);
        checkpanic self.grpcClient.initStub(self, ROOT_DESCRIPTOR_15, getDescriptorMap15());
    }

    isolated remote function hello(Request1 req, map<string[]> headers = {}) returns ([Response1, map<string[]>]|Error) {
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.OneofFieldService/hello", req, headers);
        map<string[]> resHeaders;
        anydata result = ();
        [result, resHeaders] = payload;
        var value = result.cloneWithType(Response1Typedesc);
        if (value is Response1) {
            return [value, resHeaders];
        } else {
            Error err = error InternalError("Error while constructing the message", value);
            return err;
        }
    }

    isolated remote function testOneofField(ZZZ req, map<string[]> headers = {}) returns ([ZZZ, map<string[]>]|Error) {
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.OneofFieldService/testOneofField", req, headers);
        map<string[]> resHeaders;
        anydata result = ();
        [result, resHeaders] = payload;
        var value = result.cloneWithType(ZZZTypedesc);
        if (value is ZZZ) {
            return [value, resHeaders];
        } else {
            Error err = error InternalError("Error while constructing the message", value);
            return err;
        }
    }

}
