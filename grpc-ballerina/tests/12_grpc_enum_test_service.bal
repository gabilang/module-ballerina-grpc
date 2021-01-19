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

listener Listener ep12 = new (9102, {
    host:"localhost"
});

@ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR_12,
    descMap: getDescriptorMap12()
}
service "testEnumService" on ep12 {
    isolated remote function testEnum(TestEnumServiceStringCaller caller, OrderInfo orderReq) {
        string permission = "";
        if (orderReq.mode == r) {
            permission = "r";
        }
        checkpanic caller->sendString(permission);
        checkpanic caller->complete();
    }
}

public client class TestEnumServiceStringCaller {
    private Caller caller;

    public isolated function init(Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }
    
    isolated remote function sendString(string response) returns Error? {
        return self.caller->send(response);
    }
    isolated remote function sendContextString(ContextString response) returns Error? {
        return self.caller->send(response);
    }
    
    isolated remote function sendError(Error response) returns Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.caller->complete();
    }
}

public type ContextOrderInfo record {|
    OrderInfo content;
    map<string|string[]> headers;
|};

public type OrderInfo record {
    string id = "";
    Mode mode = r;
};

public type Mode r;
public const r = "r";

const string ROOT_DESCRIPTOR_12 = "0A1F31325F677270635F656E756D5F746573745F736572766963652E70726F746F120C6772706373657276696365731A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F221B0A094F72646572496E666F120E0A026964180120012809520269642A0D0A044D6F646512050A0172100032540A0F74657374456E756D5365727669636512410A0874657374456E756D12172E6772706373657276696365732E4F72646572496E666F1A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C7565620670726F746F33";
isolated function getDescriptorMap12() returns map<string> {
    return {
        "12_grpc_enum_test_service.proto":"0A1F31325F677270635F656E756D5F746573745F736572766963652E70726F746F120C6772706373657276696365731A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F221B0A094F72646572496E666F120E0A026964180120012809520269642A0D0A044D6F646512050A0172100032540A0F74657374456E756D5365727669636512410A0874657374456E756D12172E6772706373657276696365732E4F72646572496E666F1A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C7565620670726F746F33",
        "google/protobuf/wrappers.proto":"0A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F120F676F6F676C652E70726F746F62756622230A0B446F75626C6556616C756512140A0576616C7565180120012801520576616C756522220A0A466C6F617456616C756512140A0576616C7565180120012802520576616C756522220A0A496E74363456616C756512140A0576616C7565180120012803520576616C756522230A0B55496E74363456616C756512140A0576616C7565180120012804520576616C756522220A0A496E74333256616C756512140A0576616C7565180120012805520576616C756522230A0B55496E74333256616C756512140A0576616C756518012001280D520576616C756522210A09426F6F6C56616C756512140A0576616C7565180120012808520576616C756522230A0B537472696E6756616C756512140A0576616C7565180120012809520576616C756522220A0A427974657356616C756512140A0576616C756518012001280C520576616C7565427C0A13636F6D2E676F6F676C652E70726F746F627566420D577261707065727350726F746F50015A2A6769746875622E636F6D2F676F6C616E672F70726F746F6275662F7074797065732F7772617070657273F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33"

    };
}
