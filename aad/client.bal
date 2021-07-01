// Copyright (c) 2020 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

import ballerina/http;
import ballerina/io;

# Azure AD Client Object for executing drive operations.
# 
# + httpClient - the HTTP Client
@display {
    label: "Azure AD Client", 
    iconPath: "MSOneDriveLogo.svg"
}
public client class Client {
    http:Client httpClient;

    public isolated function init(Configuration config) returns error? {
        http:BearerTokenConfig|http:OAuth2RefreshTokenGrantConfig clientConfig = config.clientConfig;
        http:ClientSecureSocket? socketConfig = config?.secureSocketConfig;
        self.httpClient = check new (BASE_URL, {
            auth: clientConfig,
            secureSocket: socketConfig
        });
    }

    @display {label: "Create User"}
    remote isolated function createUser(NewUser info, string[] queryParams = []) returns @tainted  User|Error {
        string path = check createUrl(["/users"], queryParams);
        json payload = check info.cloneWithType(json);
        http:Response response = check self.httpClient->post(path, payload);
        io:println(response);
        map<json>|string? handledResponse = check handleResponse(response);
        if (handledResponse is map<json>) {
            return check handledResponse.cloneWithType(User);
        } else {
            return error PayloadValidationError(INVALID_RESPONSE);
        } 
    }

    // @display {label: "Create Group"}
    // remote isolated function createGroup() returns @tainted @display {label: "New Group Data"} Group|error {
    //     string path = "https://graph.microsoft.com/v1.0/groups";
        
    // }
}