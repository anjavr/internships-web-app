import { ComponentFixture, TestBed } from '@angular/core/testing';

import { Worklog } from './worklog';

describe('Worklog', () => {
  let component: Worklog;
  let fixture: ComponentFixture<Worklog>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [Worklog],
    }).compileComponents();

    fixture = TestBed.createComponent(Worklog);
    component = fixture.componentInstance;
    await fixture.whenStable();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
