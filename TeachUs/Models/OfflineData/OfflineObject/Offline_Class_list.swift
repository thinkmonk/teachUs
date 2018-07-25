/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

class Offline_Class_list : Mappable {
	var course_code : String?
	var course_id : String?
	var class_id : String?
	var year_name : String?
	var year : String?
	var semester : String?
	var class_division : String?
	var subject_id : String?
	var subject_name : String?
	var subject_code : String?
	var course_name : String?
	var student_list : [Offline_Student_list]?
	var unit_syllabus_array : [Offline_Unit_syllabus_array]?

    required init?(map: Map) {

	}

    func mapping(map: Map) {

		course_code <- map["course_code"]
		course_id <- map["course_id"]
		class_id <- map["class_id"]
		year_name <- map["year_name"]
		year <- map["year"]
		semester <- map["semester"]
		class_division <- map["class_division"]
		subject_id <- map["subject_id"]
		subject_name <- map["subject_name"]
		subject_code <- map["subject_code"]
		course_name <- map["course_name"]
		student_list <- map["student_list"]
		unit_syllabus_array <- map["unit_syllabus_array"]
	}

}
