# encoding: utf-8

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Pennies::Money, "instance" do

  describe "initializing new" do

    it "given array argument with amount and currency sets instance variables" do
      amount = Pennies::Money.new([15000, :EUR])
      amount.instance_variable_get(:@cents).should == 15000
      amount.instance_variable_get(:@currency).should == Pennies::Currency.find(:EUR)
    end

    it "given array argument with amount sets instance variable" do
      amount = Pennies::Money.new([15000])
      amount.instance_variable_get(:@cents).should == 15000
    end

    it "given amount and currency arguments sets instance variables" do
      amount = Pennies::Money.new(25000, :USD)
      amount.instance_variable_get(:@cents).should == 25000
      amount.instance_variable_get(:@currency).should == Pennies::Currency.find(:USD)
    end

    it "given amount argument sets amoung instance variable only" do
      amount = Pennies::Money.new(5000)
      amount.instance_variable_get(:@cents).should == 5000
      amount.instance_variable_get(:@currency).should be_nil
    end

    it "not given any parameters sets instance variable cents to zero" do
      amount = Pennies::Money.new
      amount.instance_variable_get(:@cents).should == 0
      amount.instance_variable_get(:@currency).should be_nil
    end

    it "given an unknown currency keeps a currency as given value" do
      amount = Pennies::Money.new(1000, :XYZ)
      amount.instance_variable_get(:@cents).should == 1000
      amount.instance_variable_get(:@currency).should == :XYZ
    end

  end

  describe "multiplicating amount" do

    it "price times a fixnum returns new Pennies::Money with same currency" do
      amount = Pennies::Money.new(2500, :USD)
      result = amount * 3

      result.cents.should == 7500
      result.currency.should == Pennies::Currency.find(:USD)
    end

  end

  describe "adding amounts" do

    it "given two amounts with the same currency returns sum" do
      amount  = Pennies::Money.new(3500, :CZK)
      amount2 = Pennies::Money.new(6600, :CZK)
      sum     = amount + amount2

      sum.cents.should == 10100
      sum.currency.should == Pennies::Currency.find(:CZK)
    end

    it "given an amount and fixnum returns amount with amount currency" do
      amount  = Pennies::Money.new(1500, :CZK)
      sum     = amount + 700

      sum.cents.should == 2200
      sum.currency.should == Pennies::Currency.find(:CZK)
    end

    context "given two amounts with different currencies" do

      let(:amount_usd) { Pennies::Money.new(1000, :USD) }
      let(:amount_eur) { Pennies::Money.new(1000, :EUR) }
      let(:exchanged_amount) { Pennies::Money.new(1500, :USD) }

      it "it exchanges other amount" do
        Pennies.exchange_bank.should_receive(:convert).with(amount_eur, :USD).and_return(exchanged_amount)
        sum = amount_usd + amount_eur
      end

      it "returns a sum" do
        Pennies.exchange_bank.stub(:convert).with(amount_eur, :USD).and_return(exchanged_amount)
        sum = amount_usd + amount_eur
        sum.should == (amount_usd + exchanged_amount)
      end

    end

  end

  describe "comparing amounts" do

    describe "<" do

      it "returns true when it is less than" do
        amount = Pennies::Money.new(40000, :EUR)
        amount2 = Pennies::Money.new(50000, :EUR)
        amount.should < amount2
      end

      it "returns false when it is not less than" do
        amount = Pennies::Money.new(99000, :EUR)
        amount2 = Pennies::Money.new(50000, :EUR)
        amount.should_not < amount2
      end

      describe ">" do

        it "returns true when it is less than" do
          amount = Pennies::Money.new(80000, :EUR)
          amount2 = Pennies::Money.new(30000, :EUR)
          amount.should > amount2
        end

        it "returns false when it is not less than" do
          amount = Pennies::Money.new(1000, :EUR)
          amount2 = Pennies::Money.new(50000, :EUR)
          amount.should_not > amount2
        end

      end

    end

    describe "for equality" do

      it "returns true when both objects have same amount and currency" do
        amount = Pennies::Money.new(50000, :EUR)
        amount2 = Pennies::Money.new(50000, :EUR)
        amount.should == amount2
      end

      it "returns false when both objects have same amount but different currency" do
        amount = Pennies::Money.new(50000, :EUR)
        amount2 = Pennies::Money.new(50000, :USD)
        amount.should_not == amount2
      end

      it "returns false when both objects have same currency but different amount" do
        amount = Pennies::Money.new(3000, :USD)
        amount2 = Pennies::Money.new(50000, :USD)
        amount.should_not == amount2
      end

      it "returns false when both objects have different amount and currency" do
        amount = Pennies::Money.new(3000, :USD)
        amount2 = Pennies::Money.new(50000, :EUR)
        amount.should_not == amount2
      end

      it "returns false when other object is not Pennies::Money instance" do
        amount = Pennies::Money.new(3000, :USD)
        amount2 = 50000
        amount.should_not == amount2
      end

    end

  end

  describe "#to_a" do

    it "returns array with cents amount and currency code" do
      amount = Pennies::Money.new(500, :CZK)
      amount.to_a.should == [500, :CZK]
    end

  end

  describe "#to_i" do

    it "returns a basic amount" do
      amount = Pennies::Money.new(4500, :USD)
      amount.to_i.should == 45
    end

  end

  describe "#to_s" do

    it "returns formatted string with a currency code" do
      amount = Pennies::Money.new(5000, :USD)
      amount.to_s.should == "US$50.00"
    end

  end

end


describe Pennies::Money, "Mongo extensions" do

  describe "#set" do

    it "given Pennies::Money returns array" do
      amount = Pennies::Money.new(10000, :EUR)
      Pennies::Money.set(amount).should == [10000, :EUR]
    end

    it "given Pennies::Money with 0 returns array" do
      amount = Pennies::Money.new(0, :USD)
      Pennies::Money.set(amount).should == [0, :USD]
    end


    it "given string returns array without currency set" do
      Pennies::Money.set("30").should == [3000, nil]
    end

    it "given integer returns array without currency set" do
      Pennies::Money.set(10).should == [1000, nil]
    end

    it "given other class returns original value" do
      Pennies::Money.set({}).should == {}
    end

  end

  describe "#get" do

    it "given non-nil value returns new Pennies::Money instance" do
      amount = Pennies::Money.new(3000, :USD)
      amount2 = Pennies::Money.get([3000, :USD])
      amount.should == amount2
    end

    it "given Pennies::Money instance returns same instance" do
      amount = Pennies::Money.new(3000, :USD)
      Pennies::Money.get(amount).should == amount
    end

    it "given nil value returns nil" do
      Pennies::Money.get(nil).should be_nil
    end

  end

end