//
//  ContentView.swift
//  REER
//
//  Created by Brandon Saraceno on 12/22/22.
//

import SwiftUI

var ip = "http://192.168.50.10:3000"

struct vars {
    static var open = false
}

func postRequest(url: String) {
  
  // declare the parameter as a dictionary that contains string as key and value combination. considering inputs are valid
  
  let parameters: [String: Any] = ["id": 13, "name": "jack"]
  
  // create the url with URL
  let url = URL(string: url)! // change server url accordingly
  
  // create the session object
  let session = URLSession.shared
  
  // now create the URLRequest object using the url object
  var request = URLRequest(url: url)
  request.httpMethod = "POST" //set http method as POST
  
  // add headers for the request
  request.addValue("application/json", forHTTPHeaderField: "Content-Type") // change as per server requirements
  request.addValue("application/json", forHTTPHeaderField: "Accept")
  
  do {
    // convert parameters to Data and assign dictionary to httpBody of request
    request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
  } catch let error {
    print(error.localizedDescription)
    return
  }
  
  // create dataTask using the session object to send data to the server
  let task = session.dataTask(with: request) { data, response, error in
    
    if let error = error {
        vars.open = true
      print("Post Request Error: \(error.localizedDescription)")

        
      return
    }
    
    // ensure there is valid response code returned from this HTTP response
    guard let httpResponse = response as? HTTPURLResponse,
          (200...299).contains(httpResponse.statusCode)
    else {
      print("Invalid Response received from the server")
      return
    }
    
    // ensure there is data returned
    guard let responseData = data else {
      print("nil Data received from the server")
      return
    }
    
    do {
      // create json object from data or use JSONDecoder to convert to Model stuct
      if let jsonResponse = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) as? [String: Any] {
        print(jsonResponse)
        // handle json response
      } else {
        print("data maybe corrupted or in wrong format")
        throw URLError(.badServerResponse)
      }
    } catch let error {
      print(error.localizedDescription)
    }
  }
  // perform the task
  task.resume()
}

func extend() {
    postRequest(url: ip + "/extend")
    print("extend!")
}

func retract() {
    postRequest(url: ip + "/retract")
    print("retract!")
}

func change() {
    print("change!")
}

struct ContentView: View {
   
    var body: some View {
        VStack {
            Image(systemName: "sun.max.fill")
                .imageScale(.large)
            Text("welcome to reer.")
        }
        .padding()
        HStack {
            Button("Extend", action: extend)
                .accessibilityLabel("Label")
            Button("Retract", action: retract)
        }
        .buttonStyle(.bordered)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
