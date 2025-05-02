require_relative '../../lib/string_calculator'

RSpec::Matchers.define :add_to do |expected|
    match do |string|
        (@result = string.extend(StringCalculator).add) == expected
    end

    failure_message do |string|
        "Expected #{string} to add up to #{expected}, but got #{@result}"
    end
end

RSpec.describe StringCalculator, "#add" do
    it "returns 0 for empty string" do
        expect("").to add_to(0)
    end

    context "single number" do
        it "returns 0 for 0" do
            expect("0").to add_to(0)
        end

        it "returns 5 for 5" do
            expect("5").to add_to(5)
        end

        it "returns 27 for 27" do
            expect("27").to add_to(27)
        end
    end

    context "2 numbers" do
        it "returns 5 for 2,3" do
            expect("2,3").to add_to(5)
        end

        it "returns 27 fro 22,5" do
            expect("22,5").to add_to(27)
        end
    end

    context "3 numbers" do
        it "returns 25 for 10,12,3" do
            expect("10,12,3").to add_to(25)
        end

        it "returns 1025 for 200,700,125" do
            expect("200,700,125").to add_to(1025)
        end
    end

    it "supports newline as delimiter" do
        expect("1\n2").to add_to(3)
    end

    it "supports mixed delimiters" do
        expect("1\n2,25").to add_to(28)
    end

    it "supports alternate delimiter" do
        expect("//;\n;1;2;3").to add_to(6)
    end

    context "negative numbers" do
        it "raises an exception if it finds one" do
            expect { "-1".extend(StringCalculator).add }.to raise_error("Negatives not allowed: -1")
        end

        it "includes the negative numbers in the message" do
            expect { "-1,25,-42".extend(StringCalculator).add }.to raise_error("Negatives not allowed: -1, -42")
        end
    end
end
