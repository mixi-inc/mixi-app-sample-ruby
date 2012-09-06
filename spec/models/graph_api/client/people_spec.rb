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

describe GraphApi::Client::People do
  before :each do
    token = mock_model(GraphApi::Client::Token)
    token.stub!(:expired?)
    token.stub!(:refresh)
    @people = GraphApi::Client::People.new(token)
  end

  it 'should call lookup_friends' do
    mock_response = {status: "200 ok"}
    @people.should_receive(:lookup_friends).and_return(mock_response)
    @people.lookup_friends.should == mock_response
  end

  it 'should call lookup_my_friends' do
    mock_response = {status: "200 ok"}
    @people.should_receive(:lookup_my_friends).and_return(mock_response)
    @people.lookup_my_friends.should == mock_response
  end

  it 'should call get_my_friends' do
    mock_response = {status: "200 ok"}
    @people.should_receive(:get_my_profile).and_return(mock_response)
    @people.get_my_profile.should == mock_response
  end

  it 'should call my_user_profile' do
    mock_response = {'entry' => {'id' => 1111}}
    @people.should_receive(:get_my_profile).and_return(mock_response)
    @people.my_user_id.should == 1111
  end
end
