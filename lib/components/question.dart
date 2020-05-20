class Question {
  final String question;
  final String option1;
  final String option2;
  final String option3;
  final String option4;
  final String answer;
  List<String> op = [];
  Question(this.question, this.option1, this.option2, this.option3,
      this.option4, this.answer) {
    op.add(option1);
    op.add(option2);
    op.add(option3);
    op.add(option4);
  }
}
