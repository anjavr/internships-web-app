import { TestBed } from '@angular/core/testing';

import { Internshipservice } from './internshipservice';

describe('Internshipservice', () => {
  let service: Internshipservice;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(Internshipservice);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
