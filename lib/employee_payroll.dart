import 'dart:io';

class Employee {
 String employeeId;
 String employeeName;
 String department;

 Employee(this.employeeId, this.employeeName, this.department);

 void displayEmployeeInfo() {
   print("Employee ID : $employeeId");
   print("Name        : $employeeName");
   print("Department  : $department");
 }
}

class SalarySlip extends Employee {
 double basicSalary;
 double hra;
 double da;
 double bonus;

 SalarySlip(
     String employeeId,
     String employeeName,
     String department,
     this.basicSalary,
     this.hra,
     this.da,
     this.bonus,
     ) : super(employeeId, employeeName, department);

 // Step 4: Create Functions for Calculations
 double calculateGrossSalary() {
   return basicSalary + hra + da + bonus;
 }

 double calculateTax(double grossSalary) {
   if (grossSalary > 80000) {
     return grossSalary * 0.20; // 20% Tax
   } else if (grossSalary >= 50001 && grossSalary <= 80000) {
     return grossSalary * 0.10; // 10% Tax
   } else {
     return 0.0; // No Tax
   }
 }

 double calculateNetSalary(double grossSalary, double tax) {
   return grossSalary - tax;
 }

 void displaySalarySlip() {
   double grossSalary = calculateGrossSalary();
   double tax = calculateTax(grossSalary);
   double netSalary = calculateNetSalary(grossSalary, tax);

   print("==========================================");
   print("         EMPLOYEE SALARY SLIP             ");
   print("==========================================");
   displayEmployeeInfo();
   print("");
   print("Basic Salary : ₹${basicSalary.toStringAsFixed(0)}");
   print("HRA          : ₹${hra.toStringAsFixed(0)}");
   print("DA           : ₹${da.toStringAsFixed(0)}");
   print("Bonus        : ₹${bonus.toStringAsFixed(0)}");
   print("");
   print("Gross Salary : ₹${grossSalary.toStringAsFixed(0)}");
   print("Tax          : ₹${tax.toStringAsFixed(0)}");
   print("Net Salary   : ₹${netSalary.toStringAsFixed(0)}");
   print("==========================================");
 }
}


class Manager extends SalarySlip {
 double performanceIncentive;

 Manager(
     String employeeId,
     String employeeName,
     String department,
     double basicSalary,
     double hra,
     double da,
     double bonus,
     this.performanceIncentive,
     ) : super(employeeId, employeeName, department, basicSalary, hra, da, bonus);

 @override
 double calculateGrossSalary() {
   return basicSalary + hra + da + bonus + performanceIncentive;
 }

 @override
 void displaySalarySlip() {
   double grossSalary = calculateGrossSalary();
   double tax = calculateTax(grossSalary);
   double netSalary = calculateNetSalary(grossSalary, tax);

   print("==========================================");
   print("      MANAGER SALARY SLIP (W/ INCENTIVE)  ");
   print("==========================================");
   displayEmployeeInfo();
   print("");
   print("Basic Salary : ₹${basicSalary.toStringAsFixed(0)}");
   print("HRA          : ₹${hra.toStringAsFixed(0)}");
   print("DA           : ₹${da.toStringAsFixed(0)}");
   print("Bonus        : ₹${bonus.toStringAsFixed(0)}");
   print("Incentive    : ₹${performanceIncentive.toStringAsFixed(0)}");
   print("");
   print("Gross Salary : ₹${grossSalary.toStringAsFixed(0)}");
   print("Tax          : ₹${tax.toStringAsFixed(0)}");
   print("Net Salary   : ₹${netSalary.toStringAsFixed(0)}");
   print("==========================================");
 }
}


void main() {
 print("--- Enter Employee Details ---");
 stdout.write("Enter Employee ID: ");
 String empId = stdin.readLineSync() ?? "";

 stdout.write("Enter Employee Name: ");
 String empName = stdin.readLineSync() ?? "";

 stdout.write("Enter Department: ");
 String dept = stdin.readLineSync() ?? "";

 stdout.write("Enter Basic Salary: ");
 double basic = double.parse(stdin.readLineSync() ?? "0");

 stdout.write("Enter HRA: ");
 double hra = double.parse(stdin.readLineSync() ?? "0");

 stdout.write("Enter DA: ");
 double da = double.parse(stdin.readLineSync() ?? "0");

 stdout.write("Enter Bonus: ");
 double bonus = double.parse(stdin.readLineSync() ?? "0");


 SalarySlip employeeObj = SalarySlip(empId, empName, dept, basic, hra, da, bonus);

 print("\n");
 employeeObj.displaySalarySlip();
}
