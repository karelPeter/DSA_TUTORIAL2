import ballerina/io;
import ballerina/http;

type CourseDetail record {|
    int code;
    string designation;
    int credit;
|};
public function main() returns error? {
    //POST
    http:Client helloClient =check new ("localhost:8080"); //the port were there service is running
    json myVariable=check helloClient->/courses/create.post({"code":1, "designation":"DSA", "credit":130});
    //helloClient is the name of the client, you can rename it to anything

 io:print(myVariable.toJsonString());

//GET
    CourseDetail[] allCourse =check helloClient->get("/courses/all");
    io:print(allCourse.toJsonString());

    //DELETE


    //PUT

}
