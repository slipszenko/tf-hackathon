get '/start' do
    erb :first
end

post '/return_form_one' do
    return 'ok' # TODO - Remove this once typeform has caught up, so as not to burn Twilio credit

    request.body.rewind  # In case someone already read it
    data = JSON.parse request.body.read

    oldAnswerFormat = data['answers']
    answers = {}
    for answer in oldAnswerFormat
        if answer['type'] == "number"
            answers[answer['tags'][0]] = answer['value']['amount']
        else
            answers[answer['tags'][0]] = answer['value']
        end
    end

    # answers example:
    # {"friends_phones"=>"+34633623408,+34633623408", "name"=>"Edd", "phone"=>"+34633623408", "where"=>"Carrer de Trafalgar, Barcelona", "how_far"=>2}

    # TODO - Generate the new form based on the place and what's available here, following vars should be from places API
    typesOfFood = {
        "Spanish" => "10283092183", # Type => Google place ID
        "Italian" => "23523553223",
        "Disappointing" => "2523626236326",
        "Indian" => "352352355353",
        "French" => "124242142424"
    }

    choicesOptions = [];
    typesOfFood.each do |key, val|
        choicesOptions.push({
            "label" => key
        })
    end

    newFormJson = JSON.generate({
        "title" => "Type of food",
        "webhook_submit_url" => "https://5329d71b.ngrok.com/return_form_two",
        "fields" => [
            "type" => "multiple_choice",
            "question" => "What type of food are you tempted by?",
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

    # TODO - Save the new form ID and the number of subscribers

    'ok'
end

post '/return_form_two' do
    request.body.rewind  # In case someone already read it
    data = JSON.parse request.body.read

    # TODO - Save the answers of the user, when the number of available answers for this key is the same as the number of
    # subscribers then send out the SMSs with the results to all the other users
    # Maybe delete all from the DB after...?

    # TODO - Remove this, it was just to get an idea of what's going on
    open('shitlog2.out', 'a') { |f|
        request.body.rewind  # In case someone already read it
        request.body.read
    }

    'ok'
end
