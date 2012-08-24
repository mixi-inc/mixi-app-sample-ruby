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

describe GraphApi::Client::Persistence do
  before :each do
    token = mock_model(GraphApi::Client::Token)
    token.stub!(:expired?)
    token.stub!(:refresh)
    @persistence = GraphApi::Client::Persistence.new(token)
  end

  it 'shold call get_my_user_data' do
    mock_response = {status: "200 ok"}
    @persistence.should_receive(:get_my_user_data).and_return(mock_response)
    @persistence.get_my_user_data.should == mock_response
  end

  it 'shold call get_friends_user_data' do
    mock_response = {status: "200 ok"}
    @persistence.should_receive(:get_friends_user_data).and_return(mock_response)
    @persistence.get_friends_user_data.should == mock_response
  end

  it 'shold call get_my_user_data' do
    mock_response = {status: "200 ok"}
    @persistence.should_receive(:get_my_user_data).and_return(mock_response)
    @persistence.get_my_user_data.should == mock_response
  end

  it 'shold call register_user_data' do
    mock_response = {status: "200 ok"}
    @persistence.should_receive(:register_user_data).with('{"test" : "test"}').and_return(mock_response)
    @persistence.register_user_data('{"test" : "test"}') == mock_response
  end

  it 'shold call my_user_profile' do
    mock_response = {status: "200 ok"}
    @persistence.should_receive(:register_user_data).with('{"test" : "test"}').and_return(mock_response)
    @persistence.register_user_data('{"test" : "test"}').should == mock_response
  end

  it 'shold call delete_user_data' do
    mock_response = {status: "200 ok"}
    @persistence.should_receive(:delete_user_data).with(['hoge', 'fuga']).and_return(mock_response)
    @persistence.delete_user_data(['hoge', 'fuga']) == mock_response
  end
end
