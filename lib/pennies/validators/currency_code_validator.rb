# encoding: utf-8

class CurrencyCodeValidator < ActiveModel::EachValidator

  ISO_4217_CODES = %w(
    AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD
    BND BOB BRL BSD BTN BWP BYR BZD CAD CDF CHF CLP CNY COP CRC CUP CVE
    CYP CZK DJF DKK DOP DZD EEK EGP ERN ETB EUR FJD FKP GBP GEL GGP GHS
    GIP GMD GNF GTQ GYD HKD HNL HRK HTG HUF IDR ILS IMP INR IQD IRR ISK
    JEP JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD
    LSL LTL LVL LYD MAD MDL MGA MKD MMK MNT MOP MRO MTL MUR MVR MWK MXN
    MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR
    RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SLL SOS SPL SRD STD SVC
    SYP SZL THB TJS TMM TND TOP TRY TTD TVD TWD TZS UAH UGX USD UYU UZS
    VEB VEF VND VUV WST XAF XAG XAU XCD XDR XOF XPD XPF XPT YER ZAR ZMK
    ZWD
  )

  def initialize(record)
    super
    @case_sensitive = options[:case_sensitive].present? ? options[:case_sensitive] : false
  end

  def validate_each(record, attribute, value)
    if value.present?
      value = value.to_s.upcase unless @case_sensitive

      unless ISO_4217_CODES.include?(value.to_s.upcase)
        record.errors.add attribute, :invalid
      end
    end
  end

end