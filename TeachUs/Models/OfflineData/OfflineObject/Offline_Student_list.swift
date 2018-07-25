/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

class Offline_Student_list : Mappable {
	var class_id : String?
	var student_id : String?
	var roll_number : String?
	var f_name : String?
	var l_name : String?
	var m_name : String?
	var email : String?
	var gender : String?
	var dob : String?
	var contact : String?
    var studentFullName:String{
        return "\(f_name!) \(m_name!) \(l_name!)"
    }
	required init?(map: Map) {

	}

    func mapping(map: Map) {

		class_id <- map["class_id"]
		student_id <- map["student_id"]
		roll_number <- map["roll_number"]
		f_name <- map["f_name"]
		l_name <- map["l_name"]
		m_name <- map["m_name"]
		email <- map["email"]
		gender <- map["gender"]
		dob <- map["dob"]
		contact <- map["contact"]
	}

}
