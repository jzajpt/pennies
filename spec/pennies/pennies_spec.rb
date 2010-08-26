# encoding: utf-8

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Pennies do

  describe "exchange_bank" do

    it "should be an instance of default Pennies::ExchangeBank" do
      Pennies.exchange_bank.should be_instance_of(Pennies::ExchangeBank)
    end

  end

  describe "exchange_bank=" do

    it "should set current exchange bank" do
      class MyBank < Pennies::ExchangeBank; end
      bank_instance = MyBank.new

      Pennies.exchange_bank = bank_instance
      Pennies.exchange_bank.should == bank_instance
    end

  end

end
