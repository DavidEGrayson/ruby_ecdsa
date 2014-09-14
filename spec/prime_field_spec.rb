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
      expect(n).to receive(:%).with(prime).and_return(4)
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

    context 'if the prime is equivalent to 5 mod 8' do
      let(:field) { ECDSA::Group::Secp224k1.field }

      specify { expect(field.prime % 8).to eq 5 }

      it 'can calculate the square root of some number (d=1)' do
        n = 0xf55074f61370f55558add0478947a9fbc8f11281925f5b907b0cc12c
        expect(field.square_roots(n)).to eq [
          0xe0d2648bb5d136d71c565a34c4dd9cacf7fb15a0bed82ee371a1cc7,
          0xf1f2d9b744a2ec928e3a9a5cb3b2263530804ea5f4127d10c8e5c8a6,
        ]
      end

      it 'can calculate the square root of some number (d=-1)' do
        n = 0xcd0f7d84a2df8e7d0b97f6d9afbee85e9b1bfd0fa9862dd439285da6
        expect(field.square_roots(n)).to eq [
          0x402a63ee19abceb3a03f51c1f615bcb9822751b8178a0fd3eb088091,
          0xbfd59c11e654314c5fc0ae3e09ea43467dd8ae47e875f02b14f764dc,
        ]
      end

      it 'returns nothing for numbers without a square root' do
        n = 0xb00a6fc555ab5034b48b756bf2c9f4203702d1187112bba7fe328bed
        expect(field.square_roots(n)).to eq []
      end
    end

    context 'if the prime is 1 mod 8' do
      let(:field) { ECDSA::Group::Nistp224.field }
      specify { expect(field.prime % 8).to eq 1 }

      it 'can calculate the square root of some number' do
        n = 0x184fbd4fe8e123c572b92d3d36526bf8fd74f182cabddd89e1a7608b
        expect(field.square_roots(n)).to eq [
          0x7b2bf4e3ca4fd4d306fa7a88c8c13998b1165820a9a3dc9d31220109,
          0x84d40b1c35b02b2cf9058577373ec6664ee9a7df565c2362ceddfef8,
        ]
      end

      it 'returns nothing for a number without a square root' do
        n = 0x95a81e99ed57ac8de0dcc1be14f604b6b7c9a15feb109654390527a8
        expect(field.square_roots(n)).to eq []
      end
    end

    context 'if the prime is 2' do
      let(:field) { ECDSA::PrimeField.new(2) }

      it 'returns 0 for 0' do
        expect(field.square_roots(0)).to eq [0]
      end

      it 'returns 1 for 1' do
        expect(field.square_roots(1)).to eq [1]
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

  describe '.jacobi (private)' do
    # These test cases come from Example 2.153 from http://cacr.uwaterloo.ca/hac/
    test_cases = {
      3 => [[2, 5, 8, 11, 17, 20], [1, 4, 10, 13, 16, 19]],
      7 => [[5, 10, 13, 19, 20], [1, 2, 4, 8, 11, 16]],
      21 => [[2, 8, 10, 11, 13, 19], [1, 4, 5, 16, 17, 20]],
    }

    test_cases.each do |p, data|
      context "with p = #{p}" do
        data[0].each do |n|
          it "returns -1 for n = #{n}" do
            expect(ECDSA::PrimeField.send(:jacobi, n, p)).to eq(-1)
          end
        end

        data[1].each do |n|
          it "returns 1 for n = #{n}" do
            expect(ECDSA::PrimeField.send(:jacobi, n, p)).to eq 1
          end
        end
      end
    end
  end

end
