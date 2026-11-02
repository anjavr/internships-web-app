import { ComponentFixture, TestBed } from '@angular/core/testing';

import { MyInternships } from './my-internships';

describe('MyInternships', () => {
  let component: MyInternships;
  let fixture: ComponentFixture<MyInternships>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [MyInternships],
    }).compileComponents();

    fixture = TestBed.createComponent(MyInternships);
    component = fixture.componentInstance;
    await fixture.whenStable();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
