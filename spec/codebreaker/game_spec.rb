require 'spec_helper'

module Codebreaker
  RSpec.describe Game do
    
    let(:game) { Game.new }
        
    context "#start" do
      it "generates secret code" do
        expect(game.send(:secret_code)).not_to be_empty
      end

      it "saves 4 numbers secret code" do
        expect(game.send(:secret_code).size).to eq(4)
      end

      it "saves secret code with numbers from 1 to 6" do
        expect(game.send(:secret_code)).to match(/[1-6]+/)
      end
    end

    context "#analyze guess" do
      let(:secret_code) { game.send(:secret_code=, '1234') }
      
      it "return all marks with +" do
        expect(game.send(:analyze_guess, secret_code)).to eq('++++')
      end

      it "return all marks with -" do
        expect(game.send(:analyze_guess, secret_code.reverse)).to eq('----')
      end

      array_code = ['2234','1134','1243','1234','1234','1134','1134','1134','1234','1234','1234','1234','1234', '1212']
      array_guess = ['2265','1115','2777','2545','5124','5115','5511','5111','1555','5224','5154','5234','5134', '1211']
      array_result = ['++','++','-','--','+--','+-', '--','+-', '+','++', '+-', '+++', '++-', '+++']
      
      array_code.each_with_index do |code, i|
        it "secret_code - #{code} and guess - #{array_guess[i]} return #{array_result[i]}" do
          game.send(:secret_code=, code)
          expect(game.send(:analyze_guess, array_guess[i])).to eq(array_result[i])
        end
      end 
    end

    context "#verify guess" do
      let(:secret_code) { game.send(:secret_code=, '4321') }

      it "decrease current value of @turns by 1" do
        expect { game.verify_guess(secret_code) }.to change { game.turns }.by(-1)
      end

      it "return 'win' if result equal '++++'" do
        expect(game.send(:verify_guess, secret_code)).to eq('win')
      end

      it "return 'lose' if turns are over" do
        game.send(:turns=, 1)
        expect(game.send(:verify_guess, '1234')).to eq('lose')
      end
    end

    context "#save result" do
      after(:each) { File.delete("text.yml") }

      it "save result to file" do 
        game.save_score('kiril')
        expect(File.exist?("text.yml")).to eq true
      end
    end

    context "#hint" do
      it "decrease current value of @hints by 1" do
        expect { game.hint }.to change { game.hints }.by(-1)
      end

      it "return information message if count of hints equal 0" do
        game.send(:hints=, 0)
        expect(game.hint).to eq('Hints are over')
      end

      it "return hint with one random number of secret code" do
        game.send(:secret_code=, '1111')
        expect(game.hint).to eq("1")
      end
    end
  end
end
