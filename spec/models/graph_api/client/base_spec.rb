# Copyright (c) 2012, mixi, Inc.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
#  * Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
#  * Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#  * Neither the name of the mixi, Inc. nor the names of its contributors may
#    be used to endorse or promote products derived from this software without
#    specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.
# IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

require 'spec_helper'

describe GraphApi::Client::Base do
  before :each do
    token = mock_model(GraphApi::Client::Token)
    token.stub!(:expired?)
    token.stub!(:refresh)
    @api_client = GraphApi::Client::Base.new(token)
  end

  it 'should return correct endpints' do
    @api_client.endpoint_myself('hoge').should == 'hoge/@me/@self'
    @api_client.endpoint_friends('hoge').should == 'hoge/@me/@friends'
  end

  it 'should call get method' do
    mock_response = {status: '200 ok'}
    @api_client.should_receive(:call_api).with(:get, '/test/test', {}).and_return(mock_response)
    @api_client.get('/test/test').should == mock_response
  end

  it 'should call post method' do
    mock_response = {status: '200 ok'}
    @api_client.should_receive(:call_api).with(:post, '/test/test', {}).and_return(mock_response)
    @api_client.post('/test/test').should == mock_response
  end

  it 'should call put method' do
    mock_response = {status: '200 ok'}
    @api_client.should_receive(:call_api).with(:put, '/test/test', {}).and_return(mock_response)
    @api_client.put('/test/test').should == mock_response
  end

  it 'should call delete method' do
    mock_response = {status: '200 ok'}
    @api_client.should_receive(:call_api).with(:delete, '/test/test', {}).and_return(mock_response)
    @api_client.delete('/test/test').should == mock_response
  end

  it 'should have private_method "call_api"' do
    @response = mock(Net::HTTPResponse)
    @response.stub!(:body).and_return('{"status" : "200 ok"}')
    @https = mock(Net::HTTP)
    @https.stub!(:use_ssl=).and_return(nil)
    @https.stub!(:request).and_return(@response)
    Net::HTTP.stub!(:new).with('api.mixi-platform.com', 443).and_return(@https)
    @api_client.send(:call_api, :get, '/test/test', {} ).should == {'status' => '200 ok'}
  end
end
