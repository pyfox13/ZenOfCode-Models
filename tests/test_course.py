from models.course import Course


def test_course_fields():
    course = Course(name="Python 101", description="Intro course.")
    assert course.name == "Python 101"
    assert course.description == "Intro course."
    assert course.id is not None
