class ThingsController < ApplicationController
  def index
    if params[:count]
      count = params[:count].to_i
    else
      count = 30
    end
    things = []
    count.times do |i|
      things << "#{i}: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis sit amet rutrum est. Nam venenatis arcu sed mi efficitur, porttitor vestibulum est ultrices. Donec sit amet sapien sit amet sapien bibendum egestas. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Suspendisse vitae vehicula justo, eget dignissim ipsum. Aenean tincidunt est ligula, quis congue metus maximus sit amet. Donec lectus justo, convallis vitae nibh non, dictum finibus tellus. Mauris nisl elit, euismod eu varius et, vulputate id ex. Curabitur lobortis diam non turpis tincidunt fermentum"
    end
    render plain: things.join("\n")
  end
end