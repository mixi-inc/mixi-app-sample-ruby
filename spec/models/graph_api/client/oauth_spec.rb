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

describe GraphApi::Client::OAuth do
  before :each do
    @oauth = GraphApi::Client::OAuth.instance
  end

  it 'should return GraphApi::Client::OAuth when calling set!' do
    @oauth.set!('consumer_key', 'consumer_secret', 'redirect_uri').should be_an_instance_of GraphApi::Client::OAuth
  end

  it 'shold call create_token' do
    mock_response = {token: 'hoge'}
    @oauth.should_receive(:create_token).with('authorization_code').and_return(mock_response)
    @oauth.create_token('authorization_code').should == mock_response
  end

  it 'shold call refresh_token' do
    mock_response = {token: 'hoge'}
    @oauth.should_receive(:create_token).with('authorization_code').and_return(mock_response)
    @oauth.create_token('authorization_code').should == mock_response
  end

  it 'shold call get_token' do
    @response = mock(Net::HTTPResponse)
    @response.stub!(:body).and_return('{"status" : "200 ok"}')
    @https = mock(Net::HTTP)
    @https.stub!(:use_ssl=).and_return(nil)
    @https.stub!(:request).and_return(@response)
    Net::HTTP.stub!(:new).with('secure.mixi-platform.com', 443).and_return(@https)
    @oauth.send(:get_token, {}).should == {'status' =>  '200 ok'}
  end

end
