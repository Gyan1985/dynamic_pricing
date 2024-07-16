every 1.day, at: '2:00 pm' do
  runner "PriceAdjusterJob.perform_later"
end
