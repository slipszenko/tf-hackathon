get '/start' do
    erb :first
end

post '/return_form_one' do
    #return 'ok' # Remove

    request.body.rewind  # In case someone already read it
    data = JSON.parse request.body.read

    answers = reformat_answers(data['answers'])


    open('shitlog.out', 'a') { |f|
        f.puts answers
    }

    # answers example:
    # {"friends_phones"=>"+34633623408,+34633623408", "name"=>"Edd", "phone"=>"+34633623408", "where"=>"Carrer de Trafalgar, Barcelona", "how_far"=>2}

    # TODO - Generate the new form based on the place and what's available here, following vars should be from places API
    typesOfFood = Category.with_best_venues

    choicesOptions = typesOfFood.keys.map { |key| { label: key } }

    newFormJson = JSON.generate({
        "title" => "Type of food",
        "webhook_submit_url" => "https://5329d71b.ngrok.com/return_form_two",
        "fields" => [
            "type" => "multiple_choice",
            "question" => "What type of food are you tempted by?",
            "tags" => ["food_choice"],
            "description" => answers["name"] + " is really looking forward to dinner with you",
            "required" => true,
            "choices" => choicesOptions
        ]
    })

    uri = URI('https://api.typeform.io/v0.4/forms')
    req = Net::HTTP::Post.new(uri, {'X-API-TOKEN' => ENV['TYPEFORM_API_KEY']})
    req.body = newFormJson
    http = Net::HTTP.new(uri.hostname, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE # You should use VERIFY_PEER in production
    res = http.request(req)

    open('shitlog2.out', 'a') { |f|
        f.puts res.body
    }

    resJson = JSON.parse res.body

    formId = resJson['id']

    formRenderLink = ''
    for link in resJson['_links']
        if link['rel'] == 'form_render'
            formRenderLink = link['href']
            break
        end
    end

    @client = Twilio::REST::Client.new

    friends = answers["friends_phones"].split(',')
    friends.each do |n|
        @client.messages.create(
            from: ENV['FROM_PHONE_NUMBER'],
            to: n,
            body: 'Hello! Your friend ' + answers["name"] + " wants to go for dinner, choose where to go here " + formRenderLink
        )
    end

    subscribers = friends.length

    Event.create(
        form_id: formId,
        n_subscribers: subscribers,
        subscriber_phones: answers["friends_phones"],
        options: JSON.generate(typesOfFood)
    )

    'ok'
end

post '/return_form_two' do
    request.body.rewind  # In case someone already read it
    data = JSON.parse request.body.read

    form_id = data["uid"]
    answers = reformat_answers(data['answers'])

    # TODO - Remove this, it was just to get an idea of what's going on
    open('shitlog2.out', 'a') { |f|
        request.body.rewind  # In case someone already read it
        f.puts request.body.read
        f.puts answers
    }

    EventsAnswers.create(
        form_id: form_id,
        answer: answers['food_choice']
    )

    event = Event.find_by(form_id: form_id)
    answers = EventsAnswers.where(form_id: form_id)

    if event.n_subscribers == answers.length
        possibleAnswers = []
        for answer in answers
            possibleAnswers.push(answer.answer)
        end

        winner = most_common_value(possibleAnswers)

        # TODO - Get more details about the winner
        options = JSON.parse event.options
        winnerDetails = options[winner]

        open('shitlog2.out', 'a') { |f|
            f.puts "============ Winner Details ============"
            f.puts winnerDetails
            f.puts "========================================"
        }

        # Send out the SMSs with the results to all the other users
        friends = event.subscriber_phones.split(',')
        @client = Twilio::REST::Client.new
        friends.each do |n|
            @client.messages.create(
                from: ENV['FROM_PHONE_NUMBER'],
                to: n,
                body: "Dinner has been decided! But we can't tell you what you'll be having yet! But it was this category: " + winner
            )
        end
    end

    'ok'
end



def reformat_answers(oldAnswerFormat)
    answers = {}
    for answer in oldAnswerFormat
        if answer['type'] == "number"
            answers[answer['tags'][0]] = answer['value']['amount']
        elsif answer['type'] == "choice"
            answers[answer['tags'][0]] = answer['value']['label']
        else
            answers[answer['tags'][0]] = answer['value']
        end
    end
    answers
end

def most_common_value(a)
  a.group_by do |e|
    e
  end.values.max_by(&:size).first
end
