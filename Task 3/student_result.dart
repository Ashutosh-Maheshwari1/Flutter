void main() {
  String studentName = "John Doe";
  int rollNumber = 101;
  String course = "BCA";
  int semester = 3;

  int marksSubject1 = 85;
  int marksSubject2 = 78;
  int marksSubject3 = 91;

  int totalMarks = marksSubject1 + marksSubject2 + marksSubject3;
  double average = totalMarks / 3;
  double percentage = (totalMarks / 300) * 100;

  bool isPassed = percentage >= 40;

  marksSubject1 += 5;

  totalMarks = marksSubject1 + marksSubject2 + marksSubject3;
  average = totalMarks / 3;
  percentage = (totalMarks / 300) * 100;
  isPassed = percentage >= 40;

  print("==========================================");
  print("          STUDENT RESULT REPORT");
  print("==========================================");

  print("Student Name : $studentName");
  print("Roll Number  : $rollNumber");
  print("Course       : $course");
  print("Semester     : $semester");
  print("");

  print("Subject 1    : $marksSubject1");
  print("Subject 2    : $marksSubject2");
  print("Subject 3    : $marksSubject3");
  print("");

  print("Total Marks  : $totalMarks");
  print("Average      : ${average.toStringAsFixed(2)}");
  print("Percentage   : ${percentage.toStringAsFixed(2)}%");

  if (isPassed) {
    print("Result       : Pass");
  } else {
    print("Result       : Fail");
  }

  print("==========================================");
}
