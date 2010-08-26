# encoding: utf-8

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Pennies::ExchangeBank do

  describe "#convert" do

    it "raises NotImplementedError" do
      lambda do
        money_eur = Pennies::Money.new(10000, :EUR)
        Pennies::ExchangeBank.convert(money_eur, :USD)
      end.should raise_error(Pennies::NotImplementedError)
    end

  end

end
