describe '#convert_to_bgn' do
  it 'rounds bgn' do
    expect(convert_to_bgn(1000.2652, :bgn)).to eq 1000.27
  end

  it 'converts usd' do
    expect(convert_to_bgn(1000, :usd)).to eq 1740.8
  end

  it 'converts eur' do
    expect(convert_to_bgn(1000, :eur)).to eq 1955.7
  end

  it 'converts gbp' do
    expect(convert_to_bgn(1000, :gbp)).to eq 2641.5
  end
end

describe '#compare_prices' do
  it 'compares prices of the same currency' do
    expect(compare_prices(10, :usd, 13, :usd)).to be < 0
    expect(compare_prices(10, :eur, 10, :eur)).to eq 0
    expect(compare_prices(10, :gbp, 8, :gbp)).to be > 0
  end

  it 'compares prices of different currencies' do
    expect(compare_prices(10, :bgn, 10, :usd)).to be < 0
    expect(compare_prices(1000, :usd, 890.11607097203048, :eur)).to eq 0
    expect(compare_prices(1000, :gbp, 1000, :eur)).to be > 0
  end
end
