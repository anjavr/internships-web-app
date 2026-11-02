import { TestBed } from '@angular/core/testing';

import { Diaryservice } from './diaryservice';

describe('Diaryservice', () => {
  let service: Diaryservice;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(Diaryservice);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
