import ballerina/io;
import ballerina/http;

type CourseDetail record {|
    int code;
    string designation;
    int credit;
|};

isolated service /courses on new http:Listener(8080) {
    private int counter;
    private CourseDetail[] all_courses;
    function init() {
        self.all_courses = [];
        self.counter = 0;
    }
    isolated resource function get all() returns CourseDetail[] {
        io:println("handling a get request to /courses ...");
        lock {
            return self.all_courses.clone();
        }
    }
    isolated resource function post create(@http:Payload CourseDetail
new_course) returns json {
        io:println("handling a post requestto /courses ...");
        lock {
            self.all_courses.push(new_course.clone());
        }
        lock {
            self.counter += 1;
            return {code: new_course.code, id: self.counter.clone()};
        }
    }
    isolated resource function get course(int code) returns
CourseDetail? {
        io:println("handling a get request /courses/course ...");
        lock {
            foreach CourseDetail c in self.all_courses {
                if c.code == code {

                    return c.clone();
                }
            }
            return ();
        }
    }
    resource function delete course(int code) returns http:Ok {
        io:println("handling a delete request to /courses/course...");
        // all_courses = all_courses.filter(isolated function

        lock {
            CourseDetail[] new_courses = [];
            foreach CourseDetail c in self.all_courses {
                if c.code != code {
                    new_courses.push(c.clone());
                }
            }
            self.all_courses = new_courses.clone();
        }
        http:Ok ok = {body: "Operation Completed!"};
        return ok;
    }
}