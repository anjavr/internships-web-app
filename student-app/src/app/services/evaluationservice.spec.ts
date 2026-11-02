import { TestBed } from '@angular/core/testing';

import { Evaluationservice } from './evaluationservice';

describe('Evaluationservice', () => {
  let service: Evaluationservice;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(Evaluationservice);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
