/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

class Offline_Topic_list : Mappable {
	var topic_name : String?
	var topic_id : String?
	var topic_description : String?
	var status : String?
    var setChapterStatus:String? = "Not Started"
    var chapterStatusTheme :SyllabusCompletetionType! = .NotStarted
    var isUpdated:Bool = false

    required init?(map: Map) {

    }

    func mapping(map: Map) {

		topic_name <- map["topic_name"]
		topic_id <- map["topic_id"]
		topic_description <- map["topic_description"]
        if(map.JSON["status"] != nil){
            self.status <- map["status"]
        }else{
            self.status = ""
        }
        switch self.status {//status 2 is for completed topic / 1 is for inprogress
        case "0":
            self.chapterStatusTheme = SyllabusCompletetionType.NotStarted
            self.setChapterStatus = "Not Started"
            break
        case "1":
            self.chapterStatusTheme = SyllabusCompletetionType.InProgress
            self.setChapterStatus = "In Progess"
            break
        case "2":
            self.chapterStatusTheme = SyllabusCompletetionType.Completed
            self.setChapterStatus = "Completed"
            break
        default:
            break
        }
	}

}
