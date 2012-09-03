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

describe GraphApi::Client::Token do 

  before do 
    @token = GraphApi::Client::Token.create
  end

  it 'shold be valid' do
    @token.should be_valid
  end

  it 'should create GraphApi::Client::Token' do
    GraphApi::Client::Token.create.class.should == GraphApi::Client::Token
  end

  it 'should have GraphApi::Client::OAuth' do
    @token.oauth.class.should == GraphApi::Client::OAuth
  end

  it 'should call get!' do
    token_hash = {access_token: 'access_token', refresh_token: 'refresh_token', expires_in: 1111}
    oauth = mock(GraphApi::Client::OAuth)
    oauth.stub!(:create_token).and_return(token_hash)
    @token.oauth = oauth
    @token.stub!(:update_attributes!).and_return('GraphApi::Client::Token#update_attributes!')
    @token.get!('aaaa').should == 'GraphApi::Client::Token#update_attributes!'
  end

  it 'should call refresh!' do
    token_hash = {access_token: 'access_token', refresh_token: 'refresh_token', expires_in: 1111}
    oauth = mock(GraphApi::Client::OAuth)
    oauth.stub!(:refresh_token).and_return(token_hash)
    @token.oauth = oauth
    @token.stub!(:update_attributes!).and_return('GraphApi::Client::Token#update_attributes!')
    @token.refresh!.should == 'GraphApi::Client::Token#update_attributes!'
  end

  it 'should return true' do
    @token.stub!(:updated_at).and_return(20)
    @token.stub!(:expires_in).and_return(10)
    Time.stub!(:now).and_return(31)

    @token.expired?.should == true
  end

  it 'should return false' do
    @token.stub!(:updated_at).and_return(20)
    @token.stub!(:expires_in).and_return(10)
    Time.stub!(:now).and_return(29)

    @token.expired?.should == false
  end

end

