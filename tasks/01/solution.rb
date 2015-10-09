def convert_to_bgn(price, currency)
  in_leva = {dollars: 1.7408, euro: 1.9557, pounds: 2.6415}

  case currency
    when :bgn
      price.round(2)
    when :usd
      (price * in_leva[:dollars]).round(2)
    when :eur
      (price * in_leva[:euro]).round(2)
    when :gbp
      (price * in_leva[:pounds]).round(2)
  end
end

def compare_prices(first_price, first_currency, second_price, second_currency)
  first_price_bgn = convert_to_bgn(first_price, first_currency)
  second_price_bgn = convert_to_bgn(second_price, second_currency)
  first_price_bgn - second_price_bgn
end
