describe 'examples in README.md' do
  def puts(*a)
  end

  specify 'typical usage' do
    # Generating a private key
    require 'ecdsa'
    require 'securerandom'
    group = ECDSA::Group::Secp256k1
    private_key = 1 + SecureRandom.random_number(group.order - 1)
    puts 'private key: %#x' % private_key

    # Computing the public key for a private key
    public_key = group.generator.multiply_by_scalar(private_key)
    puts 'public key: '
    puts '  x: %#x' % public_key.x
    puts '  y: %#x' % public_key.y

    # Encoding a public key as a binary string
    public_key_string = ECDSA::Format::PointOctetString.encode(public_key, compression: true)

    # Decoding a public key from a binary string
    public_key = ECDSA::Format::PointOctetString.decode(public_key_string, group)

    # Signing a message
    require 'digest/sha2'
    message = 'ECDSA is cool.'
    digest = Digest::SHA2.digest(message)
    signature = nil
    while signature.nil?
      temp_key = 1 + SecureRandom.random_number(group.order - 1)
      signature = ECDSA.sign(group, private_key, digest, temp_key)
    end
    puts 'signature: '
    puts '  r: %#x' % signature.r
    puts '  s: %#x' % signature.s

    # Encoding a signature as a DER string
    signature_der_string = ECDSA::Format::SignatureDerString.encode(signature)

    # Decoding a signature from a DER string
    signature = ECDSA::Format::SignatureDerString.decode(signature_der_string)

    # Verifying a signature
    valid = ECDSA.valid_signature?(public_key, digest, signature)
    puts "valid: #{valid}"
  end
end
