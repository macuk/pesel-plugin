require 'test_helper'

class PeselTest < ActiveSupport::TestCase
  Valid   = %w(75120804355 74082610668 02221407563)
  Invalid = %w(75120804350 95993823492 00000000000 123)

  test "number and to_s methods" do
    (Valid + Invalid).each do |number|
      p = Pesel.new(number)
      assert number, p.number
      assert number, p.to_s
    end
  end

  test "valid? method" do
    Valid.each do |number|
      p = Pesel.new(number)
      assert p.valid?
    end

    Invalid.each do |number|
      p = Pesel.new(number)
      assert_equal false, p.valid?
    end
  end

  test "birth_date method" do
    p = Pesel.new(Valid[0])
    assert_equal Date.parse('1975-12-08'), p.birth_date
    p = Pesel.new(Valid[1])
    assert_equal Date.parse('1974-08-26'), p.birth_date
    p = Pesel.new(Valid[2])
    assert_equal Date.parse('2002-02-14'), p.birth_date
  end

  test "female? and male? methods" do
    p = Pesel.new(Valid[0])
    assert_equal false, p.female?
    assert p.male?

    p = Pesel.new(Valid[1])
    assert p.female?
    assert_equal false, p.male?

    p = Pesel.new(Valid[2])
    assert p.female?
    assert_equal false, p.male?
  end

  test "gender method" do
    p = Pesel.new(Valid[0])
    assert_equal :male, p.gender

    p = Pesel.new(Valid[1])
    assert_equal :female, p.gender

    p = Pesel.new(Valid[2])
    assert_equal :female, p.gender
  end

  test "methods that raise exception on invalid number" do
    Invalid.each do |number|
      p = Pesel.new(number)
      assert_raise Pesel::NumberInvalid do
        p.birth_date
      end
      assert_raise Pesel::NumberInvalid  do
        p.female?
      end
      assert_raise Pesel::NumberInvalid  do
        p.male?
      end
      assert_raise Pesel::NumberInvalid  do
        p.gender
      end
    end
  end
end
