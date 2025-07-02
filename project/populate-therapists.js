const mongoose = require('mongoose');
require('dotenv').config();

// Use the existing models
const { Therapist } = require('./src/models/index.js');

// Sample therapist data
const sampleTherapists = [
  {
    name: "Dr. Sarah Johnson",
    email: "sarah.johnson@mindease.com",
    phone: "+1-555-0101",
    specialty: "Anxiety & Depression",
    experience: 8,
    location: "New York, NY",
    coordinates: { type: "Point", coordinates: [-74.0060, 40.7128] }, // [longitude, latitude]
    rating: 4.8,
    hourlyRate: 150,
    availability: [
      { day: "Monday", startTime: "09:00", endTime: "17:00" },
      { day: "Tuesday", startTime: "09:00", endTime: "17:00" },
      { day: "Wednesday", startTime: "09:00", endTime: "17:00" },
      { day: "Thursday", startTime: "09:00", endTime: "17:00" },
      { day: "Friday", startTime: "09:00", endTime: "15:00" }
    ],
    bio: "Specialized in cognitive behavioral therapy with 8 years of experience helping patients overcome anxiety and depression.",
    languages: ["English", "Spanish"],
    education: ["PhD Psychology - Harvard University", "MS Clinical Psychology - NYU"],
    certifications: ["Licensed Clinical Psychologist", "CBT Certified"]
  },
  {
    name: "Dr. Michael Chen",
    email: "michael.chen@mindease.com",
    phone: "+1-555-0102",
    specialty: "Trauma & PTSD",
    experience: 12,
    location: "Los Angeles, CA",
    coordinates: { type: "Point", coordinates: [-118.2437, 34.0522] }, // [longitude, latitude]
    rating: 4.9,
    hourlyRate: 180,
    availability: [
      { day: "Monday", startTime: "10:00", endTime: "18:00" },
      { day: "Tuesday", startTime: "10:00", endTime: "18:00" },
      { day: "Wednesday", startTime: "10:00", endTime: "18:00" },
      { day: "Thursday", startTime: "10:00", endTime: "18:00" },
      { day: "Friday", startTime: "10:00", endTime: "16:00" }
    ],
    bio: "Expert in trauma therapy and PTSD treatment using EMDR and other evidence-based approaches.",
    languages: ["English", "Mandarin"],
    education: ["PhD Clinical Psychology - UCLA", "MS Psychology - Stanford"],
    certifications: ["Licensed Clinical Psychologist", "EMDR Certified", "Trauma Specialist"]
  },
  {
    name: "Dr. Emily Rodriguez",
    email: "emily.rodriguez@mindease.com",
    phone: "+1-555-0103",
    specialty: "Family & Couples Therapy",
    experience: 10,
    location: "Chicago, IL",
    coordinates: { type: "Point", coordinates: [-87.6298, 41.8781] }, // [longitude, latitude]
    rating: 4.7,
    hourlyRate: 160,
    availability: [
      { day: "Monday", startTime: "08:00", endTime: "16:00" },
      { day: "Tuesday", startTime: "08:00", endTime: "16:00" },
      { day: "Wednesday", startTime: "08:00", endTime: "16:00" },
      { day: "Thursday", startTime: "08:00", endTime: "16:00" },
      { day: "Saturday", startTime: "09:00", endTime: "13:00" }
    ],
    bio: "Specializing in family dynamics and relationship counseling with a focus on communication and conflict resolution.",
    languages: ["English", "Spanish"],
    education: ["PhD Marriage & Family Therapy - Northwestern", "MS Psychology - DePaul"],
    certifications: ["Licensed Marriage & Family Therapist", "Gottman Method Certified"]
  },
  {
    name: "Dr. James Wilson",
    email: "james.wilson@mindease.com",
    phone: "+1-555-0104",
    specialty: "Addiction & Substance Abuse",
    experience: 15,
    location: "Houston, TX",
    coordinates: { type: "Point", coordinates: [-95.3698, 29.7604] }, // [longitude, latitude]
    rating: 4.6,
    hourlyRate: 170,
    availability: [
      { day: "Monday", startTime: "09:00", endTime: "17:00" },
      { day: "Tuesday", startTime: "09:00", endTime: "17:00" },
      { day: "Wednesday", startTime: "09:00", endTime: "17:00" },
      { day: "Thursday", startTime: "09:00", endTime: "17:00" },
      { day: "Friday", startTime: "09:00", endTime: "17:00" }
    ],
    bio: "Experienced addiction counselor specializing in substance abuse recovery and relapse prevention.",
    languages: ["English"],
    education: ["PhD Addiction Psychology - UT Austin", "MS Clinical Psychology - Rice"],
    certifications: ["Licensed Addiction Counselor", "Certified Addiction Professional"]
  },
  {
    name: "Dr. Lisa Thompson",
    email: "lisa.thompson@mindease.com",
    phone: "+1-555-0105",
    specialty: "Child & Adolescent Therapy",
    experience: 9,
    location: "Phoenix, AZ",
    coordinates: { type: "Point", coordinates: [-112.0740, 33.4484] }, // [longitude, latitude]
    rating: 4.8,
    hourlyRate: 140,
    availability: [
      { day: "Monday", startTime: "14:00", endTime: "20:00" },
      { day: "Tuesday", startTime: "14:00", endTime: "20:00" },
      { day: "Wednesday", startTime: "14:00", endTime: "20:00" },
      { day: "Thursday", startTime: "14:00", endTime: "20:00" },
      { day: "Saturday", startTime: "10:00", endTime: "16:00" }
    ],
    bio: "Dedicated to helping children and teenagers navigate emotional challenges through play therapy and cognitive techniques.",
    languages: ["English"],
    education: ["PhD Child Psychology - ASU", "MS Developmental Psychology - NAU"],
    certifications: ["Licensed Child Psychologist", "Play Therapy Certified"]
  }
];

async function populateTherapists() {
  console.log('Starting therapist population script...');
  try {
    // Connect to MongoDB
    console.log('Attempting to connect to MongoDB...');
    await mongoose.connect(process.env.MONGODB_URI || 'mongodb://localhost:27017/mindease');
    console.log('✅ Connected to MongoDB successfully');

    // Clear existing therapists
    await Therapist.deleteMany({});
    console.log('Cleared existing therapists');

    // Insert sample therapists
    const result = await Therapist.insertMany(sampleTherapists);
    console.log(`Successfully added ${result.length} therapists to the database`);

    // Display added therapists
    result.forEach((therapist, index) => {
      console.log(`${index + 1}. ${therapist.name} - ${therapist.specialty} (${therapist.location})`);
    });

  } catch (error) {
    console.error('Error populating therapists:', error);
  } finally {
    await mongoose.connection.close();
    console.log('Database connection closed');
  }
}

// Run the population script
populateTherapists();
