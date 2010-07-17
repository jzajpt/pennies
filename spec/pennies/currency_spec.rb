# encoding: utf-8

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Pennies::Currency, "instance" do

  describe "initializing new" do

    it "given all arguments it sets instance variables" do
      currency = Pennies::Currency.new(:CZK, "Czech Koruna", "Kč", "%n %s")
      currency.instance_variable_get(:@code).should == :CZK
      currency.instance_variable_get(:@name).should == "Czech Koruna"
      currency.instance_variable_get(:@sign).should == "Kč"
      currency.instance_variable_get(:@format).should == "%n %s"
    end

  end

  describe "comparing currencies" do

    it "returns true when both objects have same currency code" do
      currency = Pennies::Currency.new(:EUR)
      currency2 = Pennies::Currency.new(:EUR)
      currency.should == currency2
    end

    it "returns false when both objects have different currency" do
      currency = Pennies::Currency.new(:EUR)
      currency2 = Pennies::Currency.new(:USD)
      currency.should_not == currency2
    end

    it "returns false when objects have different class" do
      currency = Pennies::Currency.new(:CAD)
      currency2 = :USD
      currency.should_not == currency2
    end

    it "returns false when objects have different class but same code" do
      currency = Pennies::Currency.new(:CAD)
      currency2 = :CAD
      currency.should_not == currency2
    end

  end

end


describe Pennies::Currency, "Mongo extensions" do

  describe "#set" do

    it "given Pennies::Currency returns a code" do
      currency = Pennies::Currency.new(:EUR, "Euro")
      Pennies::Currency.set(currency).should == :EUR
    end

    it "given string returns given string" do
      Pennies::Currency.set("EUR").should == "EUR"
    end

    it "given symbol returns given symbol" do
      Pennies::Currency.set(:JPY).should == :JPY
    end

    it "given other class returns original value" do
      Pennies::Currency.set({}).should == {}
    end

  end

  describe "#get" do

    it "given non-nil value returns new Pennies::Currency instance" do
      currency = Pennies::Currency.new(:USD)
      currency2 = Pennies::Currency.get('USD')
      currency.should == currency2
    end

    it "given Pennies::Currency instance returns same instance" do
      currency = Pennies::Currency.new(:GBP)
      Pennies::Currency.get(currency).should == currency
    end

    it "given nil value returns nil" do
      Pennies::Currency.get(nil).should be_nil
    end

  end

end