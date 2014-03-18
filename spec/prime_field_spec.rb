require 'spec_helper'

describe ECDSA::PrimeField do
  let(:prime) { 1367 }
  subject(:field) { described_class.new(prime) }

  describe '#include?' do
    it 'returns true for 0' do
      expect(field).to include 0
    end

    it 'returns true for prime-1' do
      expect(field).to include prime - 1
    end

    it 'returns false for prime' do
      expect(field).to_not include prime
    end
  end

  describe '#mod' do
    it 'returns the integer modulo the prime' do
      n = double('num')
      n.should_receive(:%).with(prime).and_return(4)
      expect(field.mod(n)).to eq 4
    end
  end

  describe '#inverse' do
    it 'when given 0 raises an exception' do
      expect { field.inverse(0) }.to raise_error ArgumentError, '0 has no multiplicative inverse.'
    end

    it 'when given 1 returns 1' do
      expect(field.inverse(1)).to eq 1
    end

    def check_inversion(n)
      inverse = field.inverse(n)
      expect(field).to include inverse
      expect(field.mod(inverse * n)).to eq 1
    end

    it 'when given prime - 1 returns the inverse' do
      check_inversion prime - 1
    end

    it 'when given 44 returns the inverse' do
      check_inversion 44
    end

    context 'for large primes' do
      let(:prime) { 0xFFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFE_FFFFFC2F }

      it 'still works' do
        check_inversion 0xd4418917_5bd60c4f_6ead9f5f_301fd4a9_a5ece4c4_7ab45186_11b4c650_77ba7a6b
      end
    end
  end

  describe '#square_roots' do
    context 'if the prime is equivalent to 3 mod 4' do
      it 'can calculate the square root of 0' do
        expect(field.square_roots(0)).to eq [0]
      end

      it 'can calculate the square root of 1' do
        expect(field.square_roots(1)).to eq [1, 1366]
      end

      it 'can calculate the square root of 1311 or 56 mod 1367' do
        expect(field.square_roots(402)).to eq [56, 1311]
      end

      it 'reports that prime-1 has no square roots' do
        expect(field.square_roots(1366)).to eq []
      end
    end
  end

  describe '#power' do
    it 'returns 1 when raising to the power 0' do
      expect(field.power(5, 0)).to eq 1
    end

    it 'returns 1 when raising 0 to the power 0' do
      expect(field.power(0, 0)).to eq 1
    end
  end

  describe '#square' do
    it 'returns 0 for 0' do
      expect(field.square(0)).to eq 0
    end

    it 'returns 1 for 1' do
      expect(field.square(1)).to eq 1
    end

    it 'returns 402 for 1311' do
      expect(field.square(1311)).to eq 402
    end

  end

end
